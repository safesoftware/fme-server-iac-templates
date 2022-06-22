# FME Server (Distributed deployment, Windows)

These terraform scripts deploy [FME Server (Distributed deployment, Windows)](https://azuremarketplace.microsoft.com/en-US/marketplace/apps/safesoftwareinc.fme-server-distributed-deployment?tab=overview) in your Azure Subscription. The scripts can be used as a boilerplate for automic deployments of the public FME Server Azure VM images in your own environment with your own configurations. The terraform scripts are split up into multiple modules to reflect the distributed architecture and to simplify modification of the resources for different scenarios.

# How to use the scripts
## Quickstart
### Prerequisites

To deploy FME Server (Distributed deployment, Windows) on Microsoft Azure from a local machine, the Azure CLI and terraform need to be installed, configured and terraform needs to be authenticated to Azure. Follow this documentation depending on your scenario: [Quickstart: Install and Configure Terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/quickstart-configure)

### Apply the deployment

Once all prerequistes are installed you confirmed that terraform successfully authenticated to Azure the terraform scripts can be deployed via the following steps

1. Review the `variables.tf` file. This file contains all variables for the deployment. Most of the variables have default values assinged, but can be changed in the `.tf` file or overridden by using the `-var` flag with the `terraform apply` command. You will be prompted for any variable that does not have a default after running the `terraform apply` command.
2. Run `terrafom apply` in your console from the directory that that holds the `main.tf` and `variables.tf` file and provide any variables you are prompted for.
3. Review the deployment plan. If the terraform script and the provided variables validated successfully the deployment plan will be output in the consoled for you to review. Additionally you will be prompted wether you want to go ahead with the deployment. If everything looks ok, go ahead with `yes`. The deployment will now provision and configure all neccessary Azure resources and start up FME Server. This will take about 10 - 20 minutes.
4. In this quickstart exmaple the terraform statefile `terraform.tfsate` will be created on on your local machine, so you can review the current state of your deployment and test the deployment. For any productive deployments it is highly recommended to not store the state file locally but in a remote location. This makes sure you can collaborate on the state and any sensitive data contained in the state file will only be accessible to authorized users. To use Azure storage as a backend for your statefile follow this documentation: [Azure storage terraform backend](https://www.terraform.io/language/settings/backends/azurerm)

### Test FME Server

Once the depl0yment is complete it is time to test FME Server. The public URL for the new FME Server can be found in the overview of the Application Gateway resource. Follow these steps to test FME Server:
1. [Log on to the Web User Interface](https://docs.safe.com/fme/html/FME_Server_Documentation/AdminGuide/Log-on-Get-Started-2-Tier.htm)
2. [Request and Install a License](https://docs.safe.com/fme/html/FME_Server_Documentation/AdminGuide/Request_and_Install_a_License-2-Tier.htm)
3. [Run Workspace](https://docs.safe.com/fme/html/FME_Server_Documentation/WebUI/Run-Workspace.htm?)

### Delete the deployment

To remove the FME Server deployment run `terrform destroy` in your console and confirm the prompt with `yes`.

## Variables
|Variable|Description|
|---|---|
|`owner` | Specifies the default value for onwer tag.|
|`rg_name` | Specifies the resource group name.|
|`location` | Specifies the location of resources.|
|`vnet_name` | Specifies the virtual network name.|
|`be_snet_name` | Specifies the backend virtual network subnet name.|
|`agw_snet_name` | Specifies the application gateway virtual network subnet name.|
|`pip_name` | Specifies the public ip name.|
|`domain_name_label` | Specifies the label for the Domain Name. Will be used to make up the FQDN.|
|`lb_name` | Specifies the load balancer name.|
|`engine_registration_lb_frontend_name` | Specifies the engine registration load balancer frontend IP configuration name.|
|`engine_registration_lb_backend_name` | Specifies the engine registration load balancer backend IP configuration name.|
|`agw_name` | Specifies the application gateway name.|
|`vm_admin_user` | Specifies the windows virual machine admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`vm_admin_pw` | Specifies the windows virual machine admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_admin_user` | Specifies the backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_admin_pw` | Specifies the backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_user` | The login for the fmeserver database (Only used for Azure SQL Server). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|
|`db_pw` | The password for the fmeserver database (Only used for Azure SQL Server. Please review the [SQL Server Password Policy](https://docs.microsoft.com/en-us/sql/relational-databases/security/password-policy?view=azuresqldb-current)). This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DOT NOT HARDCODE.|

## Output
|Output|Description|
|---|---|

## Modifying resources
The terraform scripts provide an easy way to read and modify the configuration.
### Changing Resource configurations
Most of the default resource configurations follow the minimum of the recommeneded machine specifications for FME Server. However for demanding workflows it is recommended to scale the the resources accordingly. With terraform it is easy to scale the resources by just updating the configuration (e.g. for the virtual machine scale sets of the core and engine) and rerun the `terraform apply` command.
### Changing backend DB configuration
## Use Azure SQL
A Azure SQL Server database as the FME Sever backend database can be used by changing the the module source of the database module to `./modules/database/sql_server` in the `main.tf` file. Additionally the default PowerShell script on the core virtual machine scale set (VMSS) needs to be overridden with the script provided in `./modules/database/sql_server/script`. To do this the `custom_data` property of the core VMSS can be used to upload the file and a new extension property of the core VMSS that runs the new script instead of the default script can be added. This change is already prepared in the `main.tf` file and only requires uncommneting/commenting of the respective sections in the database module and the core VMSS.
## Use exising database
The most important prerquisite to use an existing database with the distributed FME Server deployment is network connectivity between the database and the backend VNet that is created for the FME Server deployment. There are different ways to accomplish this. In the default configuration a network rule is added to the database server that is used. To use an exising Azure SQL or PostgreSQL database the exising resources can be [imported](https://www.terraform.io/cli/import) into the terraform configuration. This way the existing resources and any changes to them can also be managed be by terraform. Another option is to only provide the necessary variables in the `variables.tf` to make sure the FME core and engines can connect to the database.

## Todos
- clean up resource names and follow naming best practice
- remove uneccesary variables ()
- add output variable with FQDN of deployed server to root module
- create lb module
- create agw module