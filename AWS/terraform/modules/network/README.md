# FME Flow network module
This module creates the required network services for a distributed FME Flow deployment in AWS.
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.rds_subnet_roup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_default_route_table.fmeflow_default_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_eip.fme_flow_nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.fme_flow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.fme_flow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.fmeflow_public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_subnet_az1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_subnet_az2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet_az1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet_az2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.fmeflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private_subnet_az1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet_az2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet_az1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet_az2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.fme_flow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.private_subnet_az1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.private_subnet_az2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.fme_flow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eip_name"></a> [eip\_name](#input\_eip\_name) | Elastic IP name | `string` | n/a | yes |
| <a name="input_igw_name"></a> [igw\_name](#input\_igw\_name) | Internet gateway name | `string` | n/a | yes |
| <a name="input_nat_name"></a> [nat\_name](#input\_nat\_name) | NAT gateway name | `string` | n/a | yes |
| <a name="input_private_sn1_cidr"></a> [private\_sn1\_cidr](#input\_private\_sn1\_cidr) | CIDR range for private subnet in the first availability zone | `string` | n/a | yes |
| <a name="input_private_sn2_cidr"></a> [private\_sn2\_cidr](#input\_private\_sn2\_cidr) | CIDR range for private subnet in the second availability zone | `string` | n/a | yes |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | CDIR range from which the FME Flow Web UI and Websocket will be accessible | `string` | n/a | yes |
| <a name="input_public_sn1_cidr"></a> [public\_sn1\_cidr](#input\_public\_sn1\_cidr) | CIDR range for public subnet in the first availability zone | `string` | n/a | yes |
| <a name="input_public_sn2_cidr"></a> [public\_sn2\_cidr](#input\_public\_sn2\_cidr) | CIDR range for public subnet in the second availability zone | `string` | n/a | yes |
| <a name="input_sn_name"></a> [sn\_name](#input\_sn\_name) | Subnet name prefix | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR range for VPC | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Virtual private cloud name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_sn_az1_id"></a> [private\_sn\_az1\_id](#output\_private\_sn\_az1\_id) | Private subnet id in the first availability zone |
| <a name="output_private_sn_az2_id"></a> [private\_sn\_az2\_id](#output\_private\_sn\_az2\_id) | Private subnet id in the second availability zone |
| <a name="output_public_sn_az1_id"></a> [public\_sn\_az1\_id](#output\_public\_sn\_az1\_id) | Public subnet id in the first availability zone |
| <a name="output_public_sn_az2_id"></a> [public\_sn\_az2\_id](#output\_public\_sn\_az2\_id) | Public subnet id in the second availability zone |
| <a name="output_rds_sn_group_name"></a> [rds\_sn\_group\_name](#output\_rds\_sn\_group\_name) | Name of subnet group for RDS |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | Security group id for FME Flow deployment |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC id for FME Sever deployment |
<!-- END_TF_DOCS --> 