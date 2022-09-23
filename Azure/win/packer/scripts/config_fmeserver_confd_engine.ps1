param(
 [string] $engineregistrationhost,
 [string] $databasehostname,
 [string] $storageAccountName,
 [string] $storageAccountKey
)

# get the first part of the database hostname to use with the username
$hostShort,$rest = $databaseHostname -split '\.',2

$private_ip = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text"  -Headers @{"Metadata"="true"}

$default_values = "C:\Program Files\FMEServer\Config\values.yml"
$modified_values = "C:\Program Files\FMEServer\Config\values-modified.yml"

# write out yaml file with modified data
Remove-Item "$modified_values"
Add-Content "$modified_values" "repositoryserverrootdir: `"Z:/fmeserverdata`"" 
Add-Content "$modified_values" "fmeserverhostnamelocal: `"${engineregistrationhost}`""
Add-Content "$modified_values" "nodename: `"${private_ip}`""
Add-Content "$modified_values" "redishosts: `"${private_ip}`""
Add-Content "$modified_values" "servletport: `"8080`""
Add-Content "$modified_values" "pgsqlhostname: `"${databasehostname}`""
Add-Content "$modified_values" "pgsqlport: `"5432`""
Add-Content "$modified_values" "pgsqlpassword: `"fmeserver`""
Add-Content "$modified_values" "pgsqlpasswordescaped: `"fmeserver`""
Add-Content "$modified_values" "pgsqlconnectionstring: `"jdbc:postgresql://${databasehostname}:5432/fmeserver`""
Add-Content "$modified_values" "logprefix: `"${private_ip}_`""
Add-Content "$modified_values" "postgresrootpassword: `"postgres`""

# replace blanked out values to ensure confd runs correctly
((Get-Content -path "$default_values" -Raw) -replace '<<DATABASE_PASSWORD>>','"fmeserver"') | Set-Content -Path "$default_values"
((Get-Content -path "$default_values" -Raw) -replace '<<POSTGRES_ROOT_PASSWORD>>','"postgres"') | Set-Content -Path "$default_values"

$ErrorActionPreference = 'SilentlyContinue'
Push-Location -Path "C:\Program Files\FMEServer\Config\confd"
& "C:\Program Files\FMEServer\Config\confd\confd.exe" -confdir "C:\Program Files\FMEServer\Config\confd" -backend file -file "C:\Program Files\FMEServer\Config\values.yml" -file "$modified_values" -onetime
Pop-Location

# add ssl mode to jdbc connection string and set username to include hostname
(Get-Content "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt") `
    -replace '5432/fmeserver', '5432/fmeserver?sslmode=require' `
    -replace "DB_USERNAME=fmeserver","DB_USERNAME=fmeserver@$hostShort" |
  Out-File "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt.updated"
Move-Item -Path "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt.updated" -Destination "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt" -Force
((Get-Content "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt") -join "`n") + "`n" | Set-Content -NoNewline "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt"

# connect to the azure file share
$connectTestResult = Test-NetConnection -ComputerName $storageAccountName.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    $username = "Azure\$storageAccountName"
    $password = ConvertTo-SecureString "$storageAccountKey" -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

    # Mount the drive
    New-SmbGlobalMapping -RemotePath "\\$storageAccountName.file.core.windows.net\fmeserverdata" -Credential $cred -LocalPath Z: -FullAccess @("NT AUTHORITY\SYSTEM", "NT AUTHORITY\NetworkService") -Persistent $True

} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

# create a script with the account name and password written into it to use at startup
Write-Output "`$username = `"Azure\$storageAccountName`"" | Out-File -FilePath "C:\startup.ps1"
Write-Output "`$password = ConvertTo-SecureString `"$storageAccountKey`" -AsPlainText -Force" | Out-File -FilePath "C:\startup.ps1" -Append
Write-Output "`$cred = New-Object System.Management.Automation.PSCredential -ArgumentList (`$username, `$password)" | Out-File -FilePath "C:\startup.ps1" -Append
Write-Output "New-SmbGlobalMapping -RemotePath `"\\$storageAccountName.file.core.windows.net\fmeserverdata`" -Credential `$cred -LocalPath Z: -FullAccess @(`"NT AUTHORITY\SYSTEM`", `"NT AUTHORITY\NetworkService`") -Persistent `$True" | Out-File -FilePath "C:\startup.ps1" -Append
Write-Output "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False" | Out-File -FilePath "C:\startup.ps1" -Append

# create a scheduled task to run the above script at startup
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\startup.ps1"'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Description "Mount Azure files at startup"
Register-ScheduledTask -TaskName "AzureMountFiles" -InputObject $definition

Set-Service -Name "FME Server Engines" -StartupType "Automatic"
Start-Service -Name "FME Server Engines"

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
