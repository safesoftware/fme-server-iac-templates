$installer_url = $env:INSTALLER_URL

Write-Host "Downloading installer from $installer_url"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$installer_url" -OutFile C:\fme-flow.exe
Write-Host "Installing FME Flow..."
Start-Process C:\fme-flow.exe -Wait -ArgumentList "-s", "-dC:\FME", "-sp""COREHOSTNAME=localhost SERVLETPORT=8080 DEPLOYMENTNAME=localhost EXTERNALHOSTNAME=localhost NODENAME=localhost FMESERVERSHAREDDATA=C:\Data DATABASETYPE=PostgreSQL INSTALLTYPE=Distributed ADDLOCAL=FMEEngine /qn /norestart"""
Start-Sleep -s 60

Stop-Service -Name "FME Flow Engines"
Set-Service -Name "FME Flow Engines" -StartupType "Manual"

Remove-Item -path "C:\fme-flow.exe"
Remove-Item -Recurse -Force "C:\FME\"

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
