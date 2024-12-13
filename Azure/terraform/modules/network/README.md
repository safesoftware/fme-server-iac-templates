# FME Flow network module
This module creates the requires network resources for a distributed FME Flow deployment in Azure.
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
| [azurerm_nat_gateway.fmeflow_ng](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.fmeflow_ngpip_asc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.dns_zone_vlink](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.fme_flow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.fmeflow_ng_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.fme_flow_agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.fme_flow_be](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.fme_flow_pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.fmeflow_subnet_ng_asc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_virtual_network.fme_flow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agw_snet_name"></a> [agw\_snet\_name](#input\_agw\_snet\_name) | Application gateway virtual network subnet name | `string` | n/a | yes |
| <a name="input_be_snet_name"></a> [be\_snet\_name](#input\_be\_snet\_name) | Backend virtual network subnet name | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | Name of the private DNS Zone used by the pgsql database | `string` | n/a | yes |
| <a name="input_domain_name_label"></a> [domain\_name\_label](#input\_domain\_name\_label) | Label for the Domain Name. Will be used to make up the FQDN | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of resources | `string` | n/a | yes |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | name of the nat gateway | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Default value for onwer tag | `string` | n/a | yes |
| <a name="input_pgsql_snet_name"></a> [pgsql\_snet\_name](#input\_pgsql\_snet\_name) | Postgresql virtual network subnet name | `string` | n/a | yes |
| <a name="input_pip_name"></a> [pip\_name](#input\_pip\_name) | Public ip name | `string` | n/a | yes |
| <a name="input_publicip_nat_name"></a> [publicip\_nat\_name](#input\_publicip\_nat\_name) | name of the public ip address for the nat gateway | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Virtual network name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agw_snet_id"></a> [agw\_snet\_id](#output\_agw\_snet\_id) | Application gateway virtual network subnet id |
| <a name="output_be_snet_id"></a> [be\_snet\_id](#output\_be\_snet\_id) | Backend virtual network subnet id |
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | ID of the DNS Zone. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | Fully qualified domain name of the A DNS record associated with the public IP. |
| <a name="output_pgsql_snet_id"></a> [pgsql\_snet\_id](#output\_pgsql\_snet\_id) | pgsql virtual network subnet id |
| <a name="output_pip_id"></a> [pip\_id](#output\_pip\_id) | Public ip id |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Virtual network name |
<!-- END_TF_DOCS --> 