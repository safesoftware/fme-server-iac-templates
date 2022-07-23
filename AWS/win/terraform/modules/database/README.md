# FME Server database module
This module creates a PostgreSQL backend database and its virtual network rule for a distributed FME Server deployment in AWS.
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
| [aws_db_instance.fme_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_admin_pw"></a> [db\_admin\_pw](#input\_db\_admin\_pw) | Backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_db_admin_user"></a> [db\_admin\_user](#input\_db\_admin\_user) | Backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_rds_sn_group_name"></a> [rds\_sn\_group\_name](#input\_rds\_sn\_group\_name) | Name of subnet group for RDS | `string` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | Security group id for FME Server deployment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_dns_name"></a> [db\_dns\_name](#output\_db\_dns\_name) | Fully qualified domain name of the postgresql database server |
<!-- END_TF_DOCS --> 