# Upgrading FME Flow with IaC Templates 

### Option 1: Upgrade in Place 
Follow these steps to perform a in-place upgrade of FME Flow

1. On your existing FME Flow, create a full FME Flow backup, and download the encryption key. 
2. Try restoring the backup and encryption key to ensure their validity. 
3. Create images/AMIs for new FME deployment
4. Destroy the existing deployment: 
    a. Terraform: ```terraform destroy```
    b. Cloudformation: destroy the stack
    c. Bicep: delete resource group ```az group delete -n <resource-group-name>```
    (WARNING: this will delete the resource group and everything in it! If you want to keep the resource group, you will need to delete the individual resources via the Azure Portal or CLI)
5. Deploy the updated version of FME Flow using the same settings as the previous deployment apart from the updated FME images
6. Restore the encryption key and then the FME Flow backup

### Option 2: Upgrade onto a Second Deployment
Follow these steps to upgrade onto a second deployment of FME Flow while retaining the same FQDN

1. On your existing FME Flow deployment, create a full FME Flow backup, and download the encryption key. 
2. Create new images/AMIs for the second deployment. 
3. Create a second, separate deployment of FME Flow using the new images - a different FQDN should be generated automatically if using Bicep or AWS Cloudformation.
    a. For Terraform, you will need to update the variable "domain_name_label” default value to be something else as a placeholder.
4. Restore the encryption key, then the backup on the second instance and test that everything works as expected.
5. Change the DNS of the original FME Flow deployment to something temporary.
    a. For Terraform, update the “domain_name_label” variable value and re-apply the deployment. 
    b. For AWS, follow the directions here to update the DNS name in the load balancer to match the original deployment: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#dns-name
    c. For Azure, open the Azure Portal and go to your deployment. Open the public ip address resource (“fmeflow-pip” by default), then hit “configure” at the bottom. Here you can update your DNS name to be the same as the original one.
6. Change the DNS of the new FME Flow deployment to match the original one using the same method as above.
7. Via the WebUI, under System Configuration > Network and Email > Services, use the “Change All Hosts” button to update the service URLs to the updated one that should now be the same as the original. 
8. If everything looks good in the upgraded deployment, destroy the original, older deployment of FME Flow: 
    a. Terraform: ```terraform destroy```
    b. Cloudformation: destroy the stack
    c. Bicep: delete resource group ```az group delete -n <resource-group-name>```
    (WARNING: this will delete the resource group and everything in it! If you want to keep the resource group, you will need to delete the individual resources via the Azure Portal or CLI)



