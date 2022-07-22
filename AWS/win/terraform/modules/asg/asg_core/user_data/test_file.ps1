<powershell>
# Parameters

$databasePassword = "pw"

$databaseUsername = "username"

$databasehostname = "db-hostname.com"

$externalhostname = "hostname.com"

$storageAccountKey = "acocuntkey"

$storageAccountName = "accountname"

# Add instance to a file share domain
Set-DefaultAWSRegion -Region $awsRegion
Set-Variable -name instance_id -value (Invoke-Restmethod -uri http://169.254.169.254/latest/meta-data/instance-id)
New-SSMAssociation -InstanceId $instance_id -Name "$domainConfig"

# Create task to initialize FME Server
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Unrestricted -File C:\\config_fmeserver_confd_aws.ps1 -databasehostname $databasehostname -databasePassword $databasePassword -databaseUsername $databaseUsername -externalhostname $externalhostname -storageAccountName $storageAccountName -storageAccountKey $storageAccountKey >C:\\confd-log.txt 2>&1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Description "Initialize FME Server core"
Register-ScheduledTask -TaskName "coreInit" -InputObject $definition
</powershell>
