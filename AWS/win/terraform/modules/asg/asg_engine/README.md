# FME Server network module
This module creates the auto scaling group for the engine of a distributed FME Server deployment in AWS.
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
| [aws_autoscaling_group.fme_sever_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.fme_server_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_admin_pw"></a> [ad\_admin\_pw](#input\_ad\_admin\_pw) | Password of the admin user of the Active Directory service. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_db_dns_name"></a> [db\_dns\_name](#input\_db\_dns\_name) | Fully qualified domain name of the postgresql database server | `string` | n/a | yes |
| <a name="input_fme_engine_image_id"></a> [fme\_engine\_image\_id](#input\_fme\_engine\_image\_id) | Id of the FME Sever core image | `string` | n/a | yes |
| <a name="input_fsx_dns_name"></a> [fsx\_dns\_name](#input\_fsx\_dns\_name) | Security group id for FME Server deployment | `string` | n/a | yes |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM profile to be attached to the instances | `string` | n/a | yes |
| <a name="input_nlb_dns_name"></a> [nlb\_dns\_name](#input\_nlb\_dns\_name) | Public dns name of the network load balancer | `string` | n/a | yes |
| <a name="input_private_sn_az1_id"></a> [private\_sn\_az1\_id](#input\_private\_sn\_az1\_id) | Private subnet id in the first availability zone | `string` | n/a | yes |
| <a name="input_private_sn_az2_id"></a> [private\_sn\_az2\_id](#input\_private\_sn\_az2\_id) | Private subnet id in the second availability zone | `string` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | Security group id for FME Server deployment | `string` | n/a | yes |
| <a name="input_ssm_document_name"></a> [ssm\_document\_name](#input\_ssm\_document\_name) | Name of the SSM document used to join instances to the Active Directory | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Virtual private cloud name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS --> 