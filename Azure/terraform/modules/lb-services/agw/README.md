# FME Flow application gateway module
This module creates the application gateway for a distributed FME Flow deployment in Azure. This application gateway acts as a frontend load balancer to make sure any requests are routed to an available core in case a core becomes unavailable.
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
| [azurerm_application_gateway.fme_flow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agw_name"></a> [agw\_name](#input\_agw\_name) | description | `string` | `"fme-flow-agw"` | no |
| <a name="input_agw_snet_id"></a> [agw\_snet\_id](#input\_agw\_snet\_id) | Application gateway virtual network subnet id | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of resources | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Default value for onwer tag | `string` | n/a | yes |
| <a name="input_pip_id"></a> [pip\_id](#input\_pip\_id) | Public IP id | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Virtual network name | `string` | `"fme-flow-vnet"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_address_pool_ids"></a> [backend\_address\_pool\_ids](#output\_backend\_address\_pool\_ids) | The IDs of the Backend Address Pool |
<!-- END_TF_DOCS --> 