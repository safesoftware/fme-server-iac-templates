# FME Flow network module
This module creates the auto scaling group for the engine of a distributed FME Flow deployment in AWS.
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
| <a name="input_engine_name"></a> [engine\_name](#input\_engine\_name) | Virtual private cloud name | `string` | n/a | yes |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | The type of FME Flow Engine. Possible values are STANDARD and DYNAMIC | `string` | n/a | yes |
| <a name="input_fme_engine_image_id"></a> [fme\_engine\_image\_id](#input\_fme\_engine\_image\_id) | Id of the FME Sever core image | `string` | n/a | yes |
| <a name="input_fsx_secrets_arn"></a> [fsx\_secrets\_arn](#input\_fsx\_secrets\_arn) | Secret id for FME Flow storage | `string` | n/a | yes |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM profile to be attached to the instances | `string` | n/a | yes |
| <a name="input_nlb_dns_name"></a> [nlb\_dns\_name](#input\_nlb\_dns\_name) | Public dns name of the network load balancer | `string` | n/a | yes |
| <a name="input_node_managed"></a> [node\_managed](#input\_node\_managed) | Whether the engine nodes can be manged via the Web UI. For cpu-usage (dynamic) engines it is recommended to us 'false'. Possible values are 'true' and 'false' | `string` | n/a | yes |
| <a name="input_private_sn_az1_id"></a> [private\_sn\_az1\_id](#input\_private\_sn\_az1\_id) | Private subnet id in the first availability zone | `string` | n/a | yes |
| <a name="input_private_sn_az2_id"></a> [private\_sn\_az2\_id](#input\_private\_sn\_az2\_id) | Private subnet id in the second availability zone | `string` | n/a | yes |
| <a name="input_rds_secrets_arn"></a> [rds\_secrets\_arn](#input\_rds\_secrets\_arn) | Secret id for FME Flow backend database | `string` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | Security group id for FME Flow deployment | `string` | n/a | yes |
| <a name="input_ssm_document_name"></a> [ssm\_document\_name](#input\_ssm\_document\_name) | Name of the SSM document used to join instances to the Active Directory | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Virtual private cloud name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS --> 