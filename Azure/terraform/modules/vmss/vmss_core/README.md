# FME Flow Core VMSS module
This module creates the virtual machine scale set for the FME Core of a distributed FME Flow deployment in Azure.
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_windows_virtual_machine_scale_set.fme_flow_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agw_backend_address_pool_ids"></a> [agw\_backend\_address\_pool\_ids](#input\_agw\_backend\_address\_pool\_ids) | Application gateway backend address pool id | `set(string)` | n/a | yes |
| <a name="input_be_snet_id"></a> [be\_snet\_id](#input\_be\_snet\_id) | Backend virtual network subnet id | `string` | n/a | yes |
| <a name="input_db_admin_pw"></a> [db\_admin\_pw](#input\_db\_admin\_pw) | Specifies the backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_db_admin_user"></a> [db\_admin\_user](#input\_db\_admin\_user) | Specifies the backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_db_fqdn"></a> [db\_fqdn](#input\_db\_fqdn) | Fully qualified domain name of the postgresql database server | `string` | n/a | yes |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | Fully qualified domain name of the A DNS record associated with the public IP. | `string` | n/a | yes |
| <a name="input_instance_count_core"></a> [instance\_count\_core](#input\_instance\_count\_core) | Number of Core VM instances | `number` | n/a | yes |
| <a name="input_lb_be_address_pool_id"></a> [lb\_be\_address\_pool\_id](#input\_lb\_be\_address\_pool\_id) | Load balancer backend address pool id | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of resources | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Default value for onwer tag | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_storage_key"></a> [storage\_key](#input\_storage\_key) | FME Flow backend storage account key | `string` | n/a | yes |
| <a name="input_storage_name"></a> [storage\_name](#input\_storage\_name) | FME Flow backend storage account name | `string` | n/a | yes |
| <a name="input_vm_admin_pw"></a> [vm\_admin\_pw](#input\_vm\_admin\_pw) | Specifies the windows virual machine admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_vm_admin_user"></a> [vm\_admin\_user](#input\_vm\_admin\_user) | Specifies the windows virual machine admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS --> 



