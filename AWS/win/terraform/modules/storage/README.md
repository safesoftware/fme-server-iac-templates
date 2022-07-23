# FME Server network module
This module creates the required file share service and the Active Directory service for a distributed FME Server deployment in AWS.
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
| [aws_directory_service_directory.fme_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |
| [aws_fsx_windows_file_system.fme_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_windows_file_system) | resource |
| [aws_ssm_document.fme_server_ad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_admin_pw"></a> [ad\_admin\_pw](#input\_ad\_admin\_pw) | Password of the admin user of the Active Directory service. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_ad_name"></a> [ad\_name](#input\_ad\_name) | Name of the Active Directory service | `string` | n/a | yes |
| <a name="input_private_sn_az1_id"></a> [private\_sn\_az1\_id](#input\_private\_sn\_az1\_id) | Private subnet id in the first availability zone | `string` | n/a | yes |
| <a name="input_private_sn_az2_id"></a> [private\_sn\_az2\_id](#input\_private\_sn\_az2\_id) | Private subnet id in the second availability zone | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id for FME Sever deployment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fsx_dns_name"></a> [fsx\_dns\_name](#output\_fsx\_dns\_name) | Security group id for FME Server deployment |
| <a name="output_ssm_document_name"></a> [ssm\_document\_name](#output\_ssm\_document\_name) | Name of the SSM document used to join instances to the Active Directory |
<!-- END_TF_DOCS --> 
