# FME Flow Engine VMSS module
This module creates the virtual machine scale set for the FME Engine of a distributed FME Flow deployment in Azure.
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
| [azurerm_windows_virtual_machine_scale_set.fme_flow_engine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_be_snet_id"></a> [be\_snet\_id](#input\_be\_snet\_id) | Backend virtual network subnet id | `string` | n/a | yes |
| <a name="input_db_fqdn"></a> [db\_fqdn](#input\_db\_fqdn) | Fully qualified domain name of the postgresql database server | `string` | n/a | yes |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | The type of FME Flow Engine. Possible values are STANDARD and DYNAMIC | `string` | n/a | yes |
| <a name="input_instance_count_engine"></a> [instance\_count\_engine](#input\_instance\_count\_engine) | Number of engine VM instances | `number` | n/a | yes |
| <a name="input_lb_private_ip_address"></a> [lb\_private\_ip\_address](#input\_lb\_private\_ip\_address) | Private IP address of the load balancer | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of resources | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Default value for onwer tag | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_storage_key"></a> [storage\_key](#input\_storage\_key) | FME Flow backend storage account key | `string` | n/a | yes |
| <a name="input_storage_name"></a> [storage\_name](#input\_storage\_name) | FME Flow backend storage account name | `string` | n/a | yes |
| <a name="input_vm_admin_pw"></a> [vm\_admin\_pw](#input\_vm\_admin\_pw) | Specifies the windows virual machine admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_vm_admin_user"></a> [vm\_admin\_user](#input\_vm\_admin\_user) | Specifies the windows virual machine admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_vmss_name"></a> [vmss\_name](#input\_vmss\_name) | Name of the virtual machine scale set | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS --> 