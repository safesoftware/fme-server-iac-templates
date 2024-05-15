# FME Flow load balancer module
This module creates load balancer for a distributed FME Flow deployment in Azure. The load balancer makes sure the available engines will connect to an available core in case a core that has engines registered is becoming unavailable. 
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
| [azurerm_lb.fme_flow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.fme_flow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_rule.fme_flow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_be_snet_id"></a> [be\_snet\_id](#input\_be\_snet\_id) | Backend virtual network subnet id | `string` | n/a | yes |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | Load balancer name | `string` | `"fme-flow-lb"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of resources | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Default value for onwer tag | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_be_address_pool_id"></a> [be\_address\_pool\_id](#output\_be\_address\_pool\_id) | Backend address poll id of the load balancer |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Private IP address of the load balancer |
<!-- END_TF_DOCS --> 
