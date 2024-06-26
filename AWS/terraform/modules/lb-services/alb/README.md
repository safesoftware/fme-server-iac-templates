# FME Flow network module
This module creates the application load balancer for a distributed FME Flow deployment in AWS.
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
| [aws_lb.fme_flow_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.fme_flow_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.fme_flow_ws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.fme_flow_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.fme_flow_ws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the application load balancer | `string` | n/a | yes |
| <a name="input_public_sn_az1_id"></a> [public\_sn\_az1\_id](#input\_public\_sn\_az1\_id) | Public subnet id in the first availability zone | `string` | n/a | yes |
| <a name="input_public_sn_az2_id"></a> [public\_sn\_az2\_id](#input\_public\_sn\_az2\_id) | Public subnet id in the second availability zone | `string` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | Security group id for FME Flow deployment | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id for FME Sever deployment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | Public dns name of the application load balancer |
| <a name="output_core_target_group_arn"></a> [core\_target\_group\_arn](#output\_core\_target\_group\_arn) | The ARN of the FME Flow core target group |
| <a name="output_websocket_target_group_arn"></a> [websocket\_target\_group\_arn](#output\_websocket\_target\_group\_arn) | The ARN of the FME Flow websocket target group |
<!-- END_TF_DOCS --> 