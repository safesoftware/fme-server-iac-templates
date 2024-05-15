param(
 [string] $externalhostname,
 [string] $databasehostname,
 [string] $adminUsername,
 [string] $adminPassword,
 [string] $databaseUsername,
 [string] $databasePassword,
 [string] $storageAccountName,
 [string] $storageAccountKey
)

#Encrypt DB Password for FME Flow
$databasePasswordEncrypted = (& 'C:\Program Files\FMEServer\Clients\utilities\encryptConfigSetting.ps1' DB_PASSWORD $databasePassword | Select-Object -Last 1).substring(12) 

$private_ip = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text"  -Headers @{"Metadata"="true"}

$default_values = "C:\Program Files\FMEServer\Config\values.yml"
$modified_values = "C:\Program Files\FMEServer\Config\values-modified.yml"

# write out yaml file with modified data
Remove-Item "$modified_values"
Add-Content "$modified_values" "repositoryserverrootdir: `"Z:/fmeflowdata`"" 
Add-Content "$modified_values" "hostname: `"${private_ip}`""
Add-Content "$modified_values" "fmeflowhostnamelocal: `"${private_ip}`""
Add-Content "$modified_values" "nodename: `"${private_ip}`""
Add-Content "$modified_values" "webserverhostname: `"${externalhostname}`""
Add-Content "$modified_values" "redishosts: `"${private_ip}`""
Add-Content "$modified_values" "servletport: `"8080`""
Add-Content "$modified_values" "pgsqlcomment: `"#`"" 
Add-Content "$modified_values" "sqlservercomment: `"`""
Add-Content "$modified_values" "sqlserverconnectionstring: `"jdbc:sqlserver://${databasehostname};port=1433;databaseName=fmeflow`""
Add-Content "$modified_values" "sqlserverdatabasename: `"fmeflow`""
Add-Content "$modified_values" "sqlserverpassword: `"$databasePassword`""
Add-Content "$modified_values" "sqlserverpasswordescaped: `"$databasePassword`""
Add-Content "$modified_values" "sqlserverpasswordencrypted: `"$databasePasswordEncrypted`""
Add-Content "$modified_values" "sqlserverusername: `"$databaseUsername`""
Add-Content "$modified_values" "externalport: `"80`""
Add-Content "$modified_values" "logprefix: `"${private_ip}_`""
Add-Content "$modified_values" "postgresrootpassword: `"postgres`""
Add-Content "$modified_values" "redisdirforwardslash: `"C:/REDISDIR/`""
Add-Content "$modified_values" "enableregistrationresponsetransactionhost: `"true`""
New-Item -Path "C:\" -Name "REDISDIR" -ItemType "directory"

# replace blanked out values to ensure confd runs correctly
((Get-Content -path "$default_values" -Raw) -replace '<<DATABASE_PASSWORD>>','"fmeflow"') | Set-Content -Path "$default_values"
((Get-Content -path "$default_values" -Raw) -replace '<<POSTGRES_ROOT_PASSWORD>>','"postgres"') | Set-Content -Path "$default_values"

$ErrorActionPreference = 'SilentlyContinue'
Push-Location -Path "C:\Program Files\FMEServer\Config\confd"
& "C:\Program Files\FMEServer\Config\confd\confd.exe" -confdir "C:\Program Files\FMEServer\Config\confd" -backend file -file "$default_values" -file "$modified_values" -onetime
Pop-Location

# connect to the azure file share
$connectTestResult = Test-NetConnection -ComputerName $storageAccountName.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    $username = "Azure\$storageAccountName"
    $password = ConvertTo-SecureString "$storageAccountKey" -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

    # Mount the drive
    New-SmbGlobalMapping -RemotePath "\\$storageAccountName.file.core.windows.net\fmeflowdata" -Credential $cred -LocalPath Z: -FullAccess @("NT AUTHORITY\SYSTEM", "NT AUTHORITY\NetworkService") -Persistent $True

} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

if ( !(Test-Path -Path 'Z:\fmeflowdata\localization' -PathType Container) ) {
    New-Item -Path 'Z:\fmeflowdata' -ItemType Directory
    Copy-Item 'C:\Data\*' -Destination 'Z:\fmeflowdata' -Recurse
}

#Install SQLServer module
Install-PackageProvider NuGet -Force;
Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module SQLServer -Repository PSGallery

# Wait until database is available before writing the schema
do {
    Write-Host "Waiting until Database is up..."
	Start-Sleep 1
    Invoke-Sqlcmd -Query "SELECT @@VERSION" -ServerInstance $databasehostname -Username $adminUsername -Password $adminPassword
    $databaseReady = $?
    Write-Host $databaseReady
} until ($databaseReady)
$schemaExists = Invoke-Sqlcmd -Query "SELECT CASE WHEN COUNT(*) >= 1 THEN CAST(1 as BIT) ELSE CAST(0 as BIT) END FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'fme_config_props'" -ServerInstance $databasehostname -Database fmeflow -Username $adminUsername -Password $adminPassword
if($schemaExists[0][0] -like "*True*") {
    Write-Host "The schema already exists"
}
else {
    #Create fmeflow user in master DB
    $query_1 = "CREATE LOGIN $databaseUsername WITH PASSWORD = '$databasePassword'"
    Write-Host $query_1
    Invoke-Sqlcmd -Query $query_1 -ServerInstance $databasehostname -Username $adminUsername -Password $adminPassword
    #Assing permissions to new user
    $query_2 = "
    CREATE USER fmeflow FOR LOGIN fmeflow;
    GRANT CONTROL, TAKE OWNERSHIP, ALTER, EXECUTE, INSERT, DELETE, UPDATE, SELECT, REFERENCES, VIEW DEFINITION TO fmeflow;
    EXEC sp_addrolemember N'db_owner', N'fmeflow';
    "
    Invoke-Sqlcmd -Query $query_2 -ServerInstance $databasehostname -Database fmeflow -Username $adminUsername -Password $adminPassword
    #Run sqlserver_createDB.sql script
    Invoke-Sqlcmd -InputFile "C:\Program Files\FMEServer\Server\database\sqlserver\sqlserver_createDB.sql" -ServerInstance $databasehostname -Database fmeflow -Username $databaseUsername -Password $databasePassword | Out-File -FilePath "C:\Program Files\FMEServer\resources\logs\installation\CreateSQLServerDatabase.log"   
   } 

# create a script with the account name and password written into it to use at startup
Write-Output "`$username = `"Azure\$storageAccountName`"" | Out-File -FilePath "C:\startup.ps1"
Write-Output "`$password = ConvertTo-SecureString `"$storageAccountKey`" -AsPlainText -Force" | Out-File -FilePath "C:\startup.ps1" -Append
Write-Output "`$cred = New-Object System.Management.Automation.PSCredential -ArgumentList (`$username, `$password)" | Out-File -FilePath "C:\startup.ps1" -Append
Write-Output "New-SmbGlobalMapping -RemotePath `"\\$storageAccountName.file.core.windows.net\fmeflowdata`" -Credential `$cred -LocalPath Z: -FullAccess @(`"NT AUTHORITY\SYSTEM`", `"NT AUTHORITY\NetworkService`") -Persistent `$True" | Out-File -FilePath "C:\startup.ps1" -Append
Write-Output "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False" | Out-File -FilePath "C:\startup.ps1" -Append

# create a scheduled task to run the above script at startup
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\startup.ps1"'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Description "Mount Azure files at startup"
Register-ScheduledTask -TaskName "AzureMountFiles" -InputObject $definition

Set-Service -Name "FME Flow Core" -StartupType "Automatic"
Set-Service -Name "FMEServerAppServer" -StartupType "Automatic"
Start-Service -Name "FME Flow Core"
Start-Service -Name "FMEServerAppServer"

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False