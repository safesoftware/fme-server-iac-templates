$installer_url = $env:INSTALLER_URL

Write-Host "Downloading installer from $installer_url"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$installer_url" -OutFile C:\fme-server.exe
Write-Host "Installing FME Server..."
Start-Process C:\fme-server.exe -Wait -ArgumentList "-s", "-dC:\FME", "-sp""FMESERVERHOSTNAME=localhost SERVLETPORT=8080 DEPLOYMENTNAME=localhost WEBSERVERHOSTNAME=localhost NODENAME=localhost FMESERVERSHAREDDATA=C:\Data DATABASETYPE=PostgreSQL INSTALLTYPE=Distributed ADDLOCAL=FMEEngine /qn /norestart"""
Start-Sleep -s 60

Get-Service -Name "FME Server Engines" 
Stop-Service -Name "FME Server Engines"
Set-Service -Name "FME Server Engines" -StartupType "Manual"

Remove-Item -path "C:\fme-server.exe"
Remove-Item -Recurse -Force "C:\FME\"

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
