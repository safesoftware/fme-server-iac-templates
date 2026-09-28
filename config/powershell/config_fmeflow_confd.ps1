param(
 [string] $externalhostname,
 [string] $databasehostname,
 [string] $databaseUsername,
 [string] $databasePassword,
 [string] $storageAccountName,
 [string] $storageAccountKey
)

try {
    # try on Azure first
    $private_ip = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text"  -Headers @{"Metadata"="true"}
    # get the first part of the database hostname to use with the username
    $hostShort,$rest = $databaseHostname -split '\.',2
    # update variables for Azure
    $storageUserName = "Azure\$storageAccountName"
    $storageAccountName = "$storageAccountName.file.core.windows.net"
    $storageAccountPath = "$storageAccountName\fmeflowdata"
    $aws = $false
}
catch {
    # if that doesn't work we must be on AWS
    $private_ip = Invoke-RestMethod -Uri "http://169.254.169.254/latest/meta-data/local-ipv4"  -Headers @{"Metadata"="true"}
    # update variables for AWS
    $storageUserName = "Admin"
    $storageAccountPath = "$storageAccountName\share"
    $aws = $true
}
$fmeDatabaseUsername = "fmeflow"
$default_values = "C:\Program Files\FMEFlow\Config\values.yml"
$modified_values = "C:\Program Files\FMEFlow\Config\values-modified.yml"

# write out yaml file with modified data
Remove-Item "$modified_values"
Add-Content "$modified_values" "repositoryserverrootdir: `"Z:/fmeflowdata`"" 
Add-Content "$modified_values" "hostname: `"${private_ip}`""
Add-Content "$modified_values" "nodename: `"${private_ip}`""
Add-Content "$modified_values" "corehostname: `"${private_ip}`""
Add-Content "$modified_values" "externalhostname: `"${externalhostname}`""
Add-Content "$modified_values" "memuraihosts: `"${private_ip}`""
Add-Content "$modified_values" "servletport: `"8080`""
Add-Content "$modified_values" "pgsqlhostname: `"${databasehostname}`""
Add-Content "$modified_values" "pgsqlport: `"5432`""
Add-Content "$modified_values" "pgsqlpassword: `"fmeflow`""
Add-Content "$modified_values" "pgsqlpasswordescaped: `"fmeflow`""
Add-Content "$modified_values" "pgsqlconnectionstring: `"jdbc:postgresql://${databasehostname}:5432/fmeflow`""
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

# determine the installed FME version to select the correct confd command syntax
$fmeVersion = $null
$versionInfoPath = "C:\Program Files\FMEFlow\VersionInfo.txt"
if (Test-Path -Path $versionInfoPath) {
    $versionLine = Get-Content -Path $versionInfoPath | Where-Object { $_ -match '^VERSION\s*=' } | Select-Object -First 1
    if ($versionLine) {
        $fmeVersion = [version](($versionLine -split '=', 2)[1].Trim())
    }
}

Push-Location -Path "C:\Program Files\FMEFlow\Config\confd"
if ($fmeVersion -and $fmeVersion -lt [version]"2026.2.0.0") {
    # FME 2026.1.x or lower uses the legacy confd argument syntax
    & "C:\Program Files\FMEFlow\Config\confd\confd.exe" -confdir "C:\Program Files\FMEFlow\Config\confd" -backend file -file "$default_values" -file "$modified_values" -onetime
} else {
    # FME 2026.2.0.0 and higher (and the default when the version is unknown)
    & "C:\Program Files\FMEFlow\Config\confd\confd.exe" file --confdir "C:\Program Files\FMEFlow\Config\confd"  --file "$default_values" --file "$modified_values" --onetime
}
Pop-Location

# add ssl mode to jdbc connection string and set username to include hostname
(Get-Content "C:\Program Files\FMEFlow\Server\fmeDatabaseConfig.txt") `
    -replace '5432/fmeflow', '5432/fmeflow?sslmode=require' `
    -replace "DB_USERNAME=fmeflow","DB_USERNAME=$fmeDatabaseUsername" |
  Out-File "C:\Program Files\FMEFlow\Server\fmeDatabaseConfig.txt.updated"
Move-Item -Path "C:\Program Files\FMEFlow\Server\fmeDatabaseConfig.txt.updated" -Destination "C:\Program Files\FMEFlow\Server\fmeDatabaseConfig.txt" -Force
((Get-Content "C:\Program Files\FMEFlow\Server\fmeDatabaseConfig.txt") -join "`n") + "`n" | Set-Content -NoNewline "C:\Program Files\FMEFlow\Server\fmeDatabaseConfig.txt"

(Get-Content "C:\Program Files\FMEFlow\Server\fmeFlowWebApplicationConfig.txt") `
    -replace '5432/fmeflow', '5432/fmeflow?sslmode=require' `
    -replace 'DB_USERNAME=fmeflow',"DB_USERNAME=$fmeDatabaseUsername" |
  Out-File "C:\Program Files\FMEFlow\Server\fmeFlowWebApplicationConfig.txt.updated"
Move-Item -Path "C:\Program Files\FMEFlow\Server\fmeFlowWebApplicationConfig.txt.updated" -Destination "C:\Program Files\FMEFlow\Server\fmeFlowWebApplicationConfig.txt" -Force
((Get-Content "C:\Program Files\FMEFlow\Server\fmeFlowWebApplicationConfig.txt") -join "`n") + "`n" | Set-Content -NoNewline "C:\Program Files\FMEFlow\Server\fmeFlowWebApplicationConfig.txt"

# Build the list of accounts allowed to use the global mapping. FME Flow 2026.2 and
# higher run their services under per-service virtual accounts (NT SERVICE\<service
# name>) instead of LocalSystem, so those accounts have to be granted access here or
# the services cannot reach Z:. Only the services this image installs are listed - the
# FME Flow Database service is left out because it only touches the local PGDATA, and
# the fault-tolerant deployment uses an external PostgreSQL Flexible Server anyway.
# Names that do not resolve are skipped: a single unresolvable name fails the whole
# New-SmbGlobalMapping call, and older installers still run everything as LocalSystem.
$fullAccess = @("NT AUTHORITY\SYSTEM", "NT AUTHORITY\NetworkService")
foreach ($account in @("NT SERVICE\FME Flow Core", "NT SERVICE\FMEFlowAppServer")) {
    try {
        [void] (New-Object System.Security.Principal.NTAccount($account)).Translate([System.Security.Principal.SecurityIdentifier])
        $fullAccess += $account
    } catch {
        Write-Host "WARNING: $account did not resolve and was skipped - if FME Flow runs under it, it will not be able to reach Z:"
    }
}
Write-Host "Granting access to the Z: mapping for: $($fullAccess -join ', ')"
$fullAccessLiteral = "@(" + (($fullAccess | ForEach-Object { "`"$_`"" }) -join ", ") + ")"

# connect to the azure file share
$connectTestResult = Test-NetConnection -ComputerName $storageAccountName -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    $username = $storageUserName
    $password = ConvertTo-SecureString "$storageAccountKey" -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

    # Mount the drive
    New-SmbGlobalMapping -RemotePath "\\$storageAccountPath" -Credential $cred -LocalPath Z: -FullAccess $fullAccess -Persistent $True

} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

# Errors are being swallowed from here on, so check the mount explicitly - otherwise a
# failure to mount only shows up later as FME Flow pointing at a share that isn't there.
if (Test-Path -Path 'Z:\') {
    Write-Host "Azure file share mounted at Z:"
} else {
    Write-Host "ERROR: Z: is not available after New-SmbGlobalMapping. FME Flow will not be able to reach the shared data directory."
}

if ( !(Test-Path -Path 'Z:\fmeflowdata\localization' -PathType Container) ) {
    New-Item -Path 'Z:\fmeflowdata' -ItemType Directory
    Copy-Item 'C:\Data\*' -Destination 'Z:\fmeflowdata' -Recurse
}

# Wait until database is available before writing the schema
do {
    Write-Host "Waiting until Database is up..."
    Start-Sleep 1
    & "C:\Program Files\FMEFlow\Utilities\pgsql\bin\pg_isready.exe" -h ${databasehostname} -p 5432
    $databaseReady = $?
    Write-Host $databaseReady
} until ($databaseReady)
$env:PGPASSWORD = "fmeflow"
$schemaExists = & "C:\Program Files\FMEFlow\Utilities\pgsql\bin\psql.exe" -h ${databasehostname} -d fmeflow -p 5432 -c "SELECT EXISTS(SELECT * FROM information_schema.tables WHERE table_name = 'fme_config_props')" -w -t -U $fmeDatabaseUsername 2>&1
if($schemaExists -like "*t*") {
    Write-Host "The schema already exists"
}
else {
    $env:PGPASSWORD = $databasePassword
    $psqlPath = '"C:\Program Files\FMEFlow\Utilities\pgsql\bin\psql.exe"'
    # Create User
    $createUserCmd = "$psqlPath -d postgres -h $databasehostname -U $databaseUsername -p 5432 -f `"C:\Program Files\FMEFlow\Server\database\postgresql\postgresql_createUser.sql`" > `"C:\Program Files\FMEFlow\resources\logs\installation\CreateUser.log`" 2>&1"
    cmd.exe /c $createUserCmd

    # Create Database
    $createDBCmd = "$psqlPath -d postgres -h $databasehostname -U $databaseUsername -p 5432 -f `"C:\Program Files\FMEFlow\Server\database\postgresql\postgresql_createDB.sql`" > `"C:\Program Files\FMEFlow\resources\logs\installation\CreateDatabase.log`" 2>&1"
    cmd.exe /c $createDBCmd

    # Switch password for fmeflow DB
    $env:PGPASSWORD = "fmeflow"

    # Create Schema
    $createSchemaCmd = "$psqlPath -d fmeflow -h $databasehostname -U $fmeDatabaseUsername -p 5432 -f `"C:\Program Files\FMEFlow\Server\database\postgresql\postgresql_createSchema.sql`" > `"C:\Program Files\FMEFlow\resources\logs\installation\CreateSchema.log`" 2>&1"
    cmd.exe /c $createSchemaCmd
    
}

# create a script with the account name and password written into it to use at startup.
# It also starts the FME Flow services once Z: is confirmed available - see the comment
# on the Set-Service calls below for why the service control manager no longer does it.
$startupScript = @"
`$username = "$storageUserName"
`$password = ConvertTo-SecureString "$storageAccountKey" -AsPlainText -Force
`$cred = New-Object System.Management.Automation.PSCredential -ArgumentList (`$username, `$password)
`$fullAccess = $fullAccessLiteral

# The mapping is persistent, so SMB may have already restored it by the time this runs.
# New-SmbGlobalMapping fails when the drive letter is taken, so only map what is missing.
function Mount-FMEFlowShare {
    if (-not (Get-SmbGlobalMapping -LocalPath 'Z:' -ErrorAction SilentlyContinue)) {
        New-SmbGlobalMapping -RemotePath "\\$storageAccountPath" -Credential `$cred -LocalPath Z: -FullAccess `$fullAccess -Persistent `$True -ErrorAction SilentlyContinue
    }
}

Mount-FMEFlowShare

# Wait for the share before starting FME Flow, retrying in case networking was not ready
# yet. Bounded so an unreachable share fails the task instead of hanging it forever.
`$deadline = (Get-Date).AddMinutes(10)
while (-not (Test-Path -Path 'Z:\fmeflowdata') -and (Get-Date) -lt `$deadline) {
    Start-Sleep -Seconds 5
    Mount-FMEFlowShare
}

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

if (-not (Test-Path -Path 'Z:\fmeflowdata')) {
    Write-Output "ERROR: Z:\fmeflowdata is not available - not starting FME Flow."
    exit 1
}

Start-Service -Name "FME Flow Core"
Start-Service -Name "FMEFlowAppServer"
"@
Set-Content -Path "C:\startup.ps1" -Value $startupScript

# create a scheduled task to run the above script at startup
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\startup.ps1"'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Description "Mount Azure files at startup"
Register-ScheduledTask -TaskName "AzureMountFiles" -InputObject $definition

# Keep the services on Manual. At boot the AzureMountFiles task and the service control
# manager have no ordering between them, so an Automatic service can start before Z: is
# mounted and come up pointed at a shared data directory that isn't there. C:\startup.ps1
# starts them instead, once it has confirmed the share. Starting them here is safe - the
# mount above has already happened.
Set-Service -Name "FME Flow Core" -StartupType "Manual"
Set-Service -Name "FMEFlowAppServer" -StartupType "Manual"
Start-Service -Name "FME Flow Core"
Start-Service -Name "FMEFlowAppServer"

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# remove coreInit task on AWS only
if ($aws) {
    Unregister-ScheduledTask -TaskName "coreInit" -Confirm:$false
}
