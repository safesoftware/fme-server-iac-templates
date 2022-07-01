$installer_url = $env:INSTALLER_URL

Write-Host "Downloading installer from $installer_url"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$installer_url" -OutFile C:\fme-server.exe
Write-Host "Installing FME Server..."
Start-Process C:\fme-server.exe -Wait -ArgumentList "-s", "-dC:\FME", "-sp""FMESERVERHOSTNAME=localhost SERVLETPORT=8080 DEPLOYMENTNAME=localhost WEBSERVERHOSTNAME=localhost NODENAME=localhost FMESERVERSHAREDDATA=C:\Data DATABASETYPE=PostgreSQL INSTALLTYPE=Distributed ADDLOCAL=FMEServerCore,Services,FMEServerDatabase,Complete /qn /norestart"""  
Start-Sleep -s 60

Stop-Service -Name "FME Server Core"
Stop-Service -Name "FMEServerAppServer"
Stop-Service -Name "FME Server Database"
Set-Service -Name "FME Server Core" -StartupType "Manual"
Set-Service -Name "FMEServerAppServer" -StartupType "Manual"
Set-Service -Name "FME Server Database" -StartupType "Manual"
& cmd.exe /c 'sc.exe config "FME Server Core" depend= ""'
Remove-Item -path "C:\fme-server.exe"
Remove-Item -Recurse -Force "C:\FME\"

New-NetFirewallRule -DisplayName "Allow inbound TCP port 80" -Direction inbound -LocalPort 80 -Protocol TCP -Action Allow

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
