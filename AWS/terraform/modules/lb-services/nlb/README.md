# FME Flow network module
This module creates the network load balancer for a distributed FME Flow deployment in AWS.
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
| [aws_lb.fme_flow_nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.fme_flow_engine-registration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.fme_flow_engine-registration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nlb_name"></a> [nlb\_name](#input\_nlb\_name) | Name of the network load balancer | `string` | n/a | yes |
| <a name="input_private_sn_az1_id"></a> [private\_sn\_az1\_id](#input\_private\_sn\_az1\_id) | Private subnet id in the first availability zone | `string` | n/a | yes |
| <a name="input_private_sn_az2_id"></a> [private\_sn\_az2\_id](#input\_private\_sn\_az2\_id) | Private subnet id in the second availability zone | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id for FME Sever deployment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_engine_registration_target_group_arn"></a> [engine\_registration\_target\_group\_arn](#output\_engine\_registration\_target\_group\_arn) | The ARN of the FME Flow engine registration target group |
| <a name="output_nlb_dns_name"></a> [nlb\_dns\_name](#output\_nlb\_dns\_name) | Public dns name of the network load balancer |
<!-- END_TF_DOCS --> 