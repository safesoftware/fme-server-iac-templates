$installer_url = $env:INSTALLER_URL

Write-Host "Downloading installer from $installer_url"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$installer_url" -OutFile C:\fme-flow.exe
Write-Host "Installing FME Flow..."
Start-Process C:\fme-flow.exe -Wait -ArgumentList "-s", "-dC:\FME", "-sp""COREHOSTNAME=localhost EXTERNALHOSTNAME=localhost SERVLETPORT=8080 DEPLOYMENTNAME=localhost NODENAME=localhost FMEFLOWSHAREDDATA=C:\Data DATABASETYPE=PostgreSQL INSTALLTYPE=Distributed ADDLOCAL=FMEFlowCore,Services,FMEFlowDatabase /qn /norestart"""  
Start-Sleep -s 60

Stop-Service -Name "FME Flow Core"
Stop-Service -Name "FMEFlowAppServer"
Stop-Service -Name "FME Flow Database"
Set-Service -Name "FME Flow Core" -StartupType "Manual"
Set-Service -Name "FMEFlowAppServer" -StartupType "Manual"
Set-Service -Name "FME Flow Database" -StartupType "Manual"
& cmd.exe /c 'sc.exe config "FME Flow Core" depend= ""'
Remove-Item -path "C:\fme-flow.exe"
Remove-Item -Recurse -Force "C:\FME\"

New-NetFirewallRule -DisplayName "Allow inbound TCP port 80" -Direction inbound -LocalPort 80 -Protocol TCP -Action Allow

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
