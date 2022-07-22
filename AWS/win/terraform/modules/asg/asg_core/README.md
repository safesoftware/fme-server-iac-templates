# FME Server network module
This module creates the auto scaling group for the core of a distributed FME Server deployment in AWS.
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
| [aws_launch_template.fme_server_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_databasePassword"></a> [databasePassword](#input\_databasePassword) | Admin passoword for the RDS database. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DOT NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_databaseUsername"></a> [databaseUsername](#input\_databaseUsername) | Admin username for the RDS database. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DOT NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_databasehostname"></a> [databasehostname](#input\_databasehostname) | DNS name of the RDS database | `string` | n/a | yes |
| <a name="input_domainConfig"></a> [domainConfig](#input\_domainConfig) | Name of the domain configuration used to add new instances to the active directory domain | `string` | n/a | yes |
| <a name="input_externalhostname"></a> [externalhostname](#input\_externalhostname) | Public DNS name of the application load balancer | `string` | n/a | yes |
| <a name="input_fme_core_image_id"></a> [fme\_core\_image\_id](#input\_fme\_core\_image\_id) | Id of the FME Sever core image | `string` | n/a | yes |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM profile to be attached to the instances | `string` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | Security group id for FME Server deployment | `string` | n/a | yes |
| <a name="input_storageAccountKey"></a> [storageAccountKey](#input\_storageAccountKey) | Password for the file share user | `string` | n/a | yes |
| <a name="input_storageAccountName"></a> [storageAccountName](#input\_storageAccountName) | Public DNS name of the FSx file share | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Virtual private cloud name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_sn_az1_id"></a> [private\_sn\_az1\_id](#output\_private\_sn\_az1\_id) | Private subnet id in the first availability zone |
| <a name="output_private_sn_az2_id"></a> [private\_sn\_az2\_id](#output\_private\_sn\_az2\_id) | Private subnet id in the second availability zone |
| <a name="output_public_sn_az1_id"></a> [public\_sn\_az1\_id](#output\_public\_sn\_az1\_id) | Public subnet id in the first availability zone |
| <a name="output_public_sn_az2_id"></a> [public\_sn\_az2\_id](#output\_public\_sn\_az2\_id) | Public subnet id in the second availability zone |
| <a name="output_rds_sn_group_name"></a> [rds\_sn\_group\_name](#output\_rds\_sn\_group\_name) | Name of subnet group for RDS |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC id for FME Sever deployment |
<!-- END_TF_DOCS --> 