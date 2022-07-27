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
| [aws_autoscaling_group.fme_sever_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.fme_server_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_dns_name"></a> [alb\_dns\_name](#input\_alb\_dns\_name) | Public dns name of the application load balancer | `string` | n/a | yes |
| <a name="input_core_target_group_arn"></a> [core\_target\_group\_arn](#input\_core\_target\_group\_arn) | The ARN of the FME Server core target group | `string` | n/a | yes |
| <a name="input_engine_registration_target_group_arn"></a> [engine\_registration\_target\_group\_arn](#input\_engine\_registration\_target\_group\_arn) | The ARN of the FME Server engine registration target group | `string` | n/a | yes |
| <a name="input_fme_core_image_id"></a> [fme\_core\_image\_id](#input\_fme\_core\_image\_id) | Id of the FME Sever core image | `string` | n/a | yes |
| <a name="input_fsx_secrets_arn"></a> [fsx\_secrets\_arn](#input\_fsx\_secrets\_arn) | Secret id for FME Server storage | `string` | n/a | yes |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM profile to be attached to the instances | `string` | n/a | yes |
| <a name="input_private_sn_az1_id"></a> [private\_sn\_az1\_id](#input\_private\_sn\_az1\_id) | Private subnet id in the first availability zone | `string` | n/a | yes |
| <a name="input_private_sn_az2_id"></a> [private\_sn\_az2\_id](#input\_private\_sn\_az2\_id) | Private subnet id in the second availability zone | `string` | n/a | yes |
| <a name="input_rds_secrets_arn"></a> [rds\_secrets\_arn](#input\_rds\_secrets\_arn) | Secret id for FME Server backend database | `string` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | Security group id for FME Server deployment | `string` | n/a | yes |
| <a name="input_ssm_document_name"></a> [ssm\_document\_name](#input\_ssm\_document\_name) | Name of the SSM document used to join instances to the Active Directory | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Virtual private cloud name | `string` | n/a | yes |
| <a name="input_websocket_target_group_arn"></a> [websocket\_target\_group\_arn](#input\_websocket\_target\_group\_arn) | The ARN of the FME Server websocket target group | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS --> 