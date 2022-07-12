param(
    [string] $externalhostname,
    [string] $databasehostname,
    [string] $databaseUsername,
    [string] $databasePassword,
    [string] $storageAccountName,
    [string] $storageAccountKey
   )
   
   $private_ip = Invoke-RestMethod -Uri "http://169.254.169.254/latest/meta-data/local-ipv4"  -Headers @{"Metadata"="true"}
   
   $default_values = "C:\Program Files\FMEServer\Config\values.yml"
   $modified_values = "C:\Program Files\FMEServer\Config\values-modified.yml"
   
   # write out yaml file with modified data
   Remove-Item "$modified_values"
   Add-Content "$modified_values" "repositoryserverrootdir: `"Z:/fmeserverdata`"" 
   Add-Content "$modified_values" "hostname: `"${private_ip}`""
   Add-Content "$modified_values" "fmeserverhostnamelocal: `"${private_ip}`""
   Add-Content "$modified_values" "nodename: `"${private_ip}`""
   Add-Content "$modified_values" "webserverhostname: `"${externalhostname}`""
   Add-Content "$modified_values" "redishosts: `"${private_ip}`""
   Add-Content "$modified_values" "servletport: `"8080`""
   Add-Content "$modified_values" "pgsqlhostname: `"${databasehostname}`""
   Add-Content "$modified_values" "pgsqlport: `"5432`""
   Add-Content "$modified_values" "pgsqlpassword: `"fmeserver`""
   Add-Content "$modified_values" "pgsqlpasswordescaped: `"fmeserver`""
   Add-Content "$modified_values" "pgsqlconnectionstring: `"jdbc:postgresql://${databasehostname}:5432/fmeserver`""
   Add-Content "$modified_values" "externalport: `"80`""
   Add-Content "$modified_values" "logprefix: `"${private_ip}_`""
   Add-Content "$modified_values" "postgresrootpassword: `"postgres`""
   Add-Content "$modified_values" "redisdirforwardslash: `"C:/REDISDIR/`""
   Add-Content "$modified_values" "enableregistrationresponsetransactionhost: `"true`""
   New-Item -Path "C:\" -Name "REDISDIR" -ItemType "directory"
   
   # replace blanked out values to ensure confd runs correctly
   ((Get-Content -path "$default_values" -Raw) -replace '<<DATABASE_PASSWORD>>','"fmeserver"') | Set-Content -Path "$default_values"
   ((Get-Content -path "$default_values" -Raw) -replace '<<POSTGRES_ROOT_PASSWORD>>','"postgres"') | Set-Content -Path "$default_values"
   
   $ErrorActionPreference = 'SilentlyContinue'
   Push-Location -Path "C:\Program Files\FMEServer\Config\confd"
   & "C:\Program Files\FMEServer\Config\confd\confd.exe" -confdir "C:\Program Files\FMEServer\Config\confd" -backend file -file "$default_values" -file "$modified_values" -onetime
   Pop-Location
   
   # add ssl mode to jdbc connection string and set username to include hostname
   (Get-Content "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt") `
       -replace '5432/fmeserver', '5432/fmeserver?sslmode=require' `
       -replace "DB_USERNAME=fmeserver","DB_USERNAME=fmeserver" |
     Out-File "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt.updated"
   Move-Item -Path "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt.updated" -Destination "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt" -Force
   ((Get-Content "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt") -join "`n") + "`n" | Set-Content -NoNewline "C:\Program Files\FMEServer\Server\fmeDatabaseConfig.txt"
   
   (Get-Content "C:\Program Files\FMEServer\Server\fmeServerWebApplicationConfig.txt") `
       -replace '5432/fmeserver', '5432/fmeserver?sslmode=require' `
       -replace 'DB_USERNAME=fmeserver',"DB_USERNAME=fmeserver" |
     Out-File "C:\Program Files\FMEServer\Server\fmeServerWebApplicationConfig.txt.updated"
   Move-Item -Path "C:\Program Files\FMEServer\Server\fmeServerWebApplicationConfig.txt.updated" -Destination "C:\Program Files\FMEServer\Server\fmeServerWebApplicationConfig.txt" -Force
   ((Get-Content "C:\Program Files\FMEServer\Server\fmeServerWebApplicationConfig.txt") -join "`n") + "`n" | Set-Content -NoNewline "C:\Program Files\FMEServer\Server\fmeServerWebApplicationConfig.txt"
   
   # connect to the azure file share
   $connectTestResult = Test-NetConnection -ComputerName $storageAccountName -Port 445
   if ($connectTestResult.TcpTestSucceeded) {
       # Save the password so the drive will persist on reboot
       $username = "Admin"
       $password = ConvertTo-SecureString "$storageAccountKey" -AsPlainText -Force
       $cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
   
       # Mount the drive
       New-SmbGlobalMapping -RemotePath "\\$storageAccountName\share" -Credential $cred -LocalPath Z: -FullAccess @("NT AUTHORITY\SYSTEM", "NT AUTHORITY\NetworkService", "Administrator") -Persistent $True
   
   } else {
       Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
   }
   
   if ( !(Test-Path -Path 'Z:\fmeserverdata\localization' -PathType Container) ) {
       New-Item -Path 'Z:\fmeserverdata' -ItemType Directory
       Copy-Item 'C:\Data\*' -Destination 'Z:\fmeserverdata' -Recurse
   }
   
   # Wait until database is available before writing the schema
   do {
       Write-Host "Waiting until Database is up..."
       Start-Sleep 1
       & "C:\Program Files\FMEServer\Utilities\pgsql\bin\pg_isready.exe" -h ${databasehostname} -p 5432
       $databaseReady = $?
       Write-Host $databaseReady
   } until ($databaseReady)
   $env:PGPASSWORD = "fmeserver"
   $schemaExists = & "C:\Program Files\FMEServer\Utilities\pgsql\bin\psql.exe" -h ${databasehostname} -d fmeserver -p 5432 -c "SELECT EXISTS(SELECT * FROM information_schema.tables WHERE table_name = 'fme_config_props')" -w -t -U fmeserver 2>&1
   if($schemaExists -like "*t*") {
       Write-Host "The schema already exists"
   }
   else {
       $env:PGPASSWORD = $databasePassword
   
       & "C:\Program Files\FMEServer\Utilities\pgsql\bin\psql.exe" -d postgres -h $databasehostname -U $databaseUsername -p 5432 -f "C:\Program Files\FMEServer\Server\database\postgresql\postgresql_createUser.sql" >"C:\Program Files\FMEServer\resources\logs\installation\CreateUser.log" 2>&1
       & "C:\Program Files\FMEServer\Utilities\pgsql\bin\psql.exe" -d postgres -h $databasehostname -U $databaseUsername -p 5432 -f "C:\Program Files\FMEServer\Server\database\postgresql\postgresql_createDB.sql" >"C:\Program Files\FMEServer\resources\logs\installation\CreateDatabase.log" 2>&1
   
       $env:PGPASSWORD = "fmeserver"
       & "C:\Program Files\FMEServer\Utilities\pgsql\bin\psql.exe" -d fmeserver -h $databasehostname -U fmeserver -p 5432 -f "C:\Program Files\FMEServer\Server\database\postgresql\postgresql_createSchema.sql" >"C:\Program Files\FMEServer\resources\logs\installation\CreateSchema.log" 2>&1
   }
   
   # create a script with the account name and password written into it to use at startup
   Write-Output "`$username = `"Admin`"" | Out-File -FilePath "C:\startup.ps1"
   Write-Output "`$password = ConvertTo-SecureString `"$storageAccountKey`" -AsPlainText -Force" | Out-File -FilePath "C:\startup.ps1" -Append
   Write-Output "`$cred = New-Object System.Management.Automation.PSCredential -ArgumentList (`$username, `$password)" | Out-File -FilePath "C:\startup.ps1" -Append
   Write-Output "New-SmbGlobalMapping -RemotePath `"\\$storageAccountName\share`" -Credential `$cred -LocalPath Z: -FullAccess @(`"NT AUTHORITY\SYSTEM`", `"NT AUTHORITY\NetworkService`") -Persistent `$True" | Out-File -FilePath "C:\startup.ps1" -Append
   Write-Output "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False" | Out-File -FilePath "C:\startup.ps1" -Append
   
   # create a scheduled task to run the above script at startup
   $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\startup.ps1"'
   $trigger = New-ScheduledTaskTrigger -AtStartup
   $principal = New-ScheduledTaskPrincipal -UserId SYSTEM -LogonType ServiceAccount -RunLevel Highest
   $definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Description "Mount Azure files at startup"
   Register-ScheduledTask -TaskName "AzureMountFiles" -InputObject $definition
   
   Set-Service -Name "FME Server Core" -StartupType "Automatic"
   Set-Service -Name "FMEServerAppServer" -StartupType "Automatic"
   Start-Service -Name "FME Server Core"
   Start-Service -Name "FMEServerAppServer"
   
   Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    
   