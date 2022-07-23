# FME Server (Distributed deployment, Windows)
These terraform scripts deploy a distributed FME Server running on windows ec2 instances in AWS. The scripts can be used as a boilerplate for automic deployments of the public FME Server AMIs in your own environment with your own configurations. The terraform scripts are split up into multiple modules to reflect the distributed architecture and to simplify modification of the resources for different scenarios.

# How to use the scripts
## Quickstart
### Prerequisites

To deploy FME Server (Distributed deployment, Windows) on AWS from a local machine, the AWS CLI and terraform need to be installed, configured and terraform needs to be authenticated to AWS. Follow this documentation depending on your scenario:
1. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [Install AWS CLI](https://aws.amazon.com/cli/)


### Apply the deployment

Once all prerequistes are installed you confirmed that terraform successfully authenticated to AWS the terraform scripts can be deployed via the following steps

1. Review the `variables.tf` file. This file contains all variables for the deployment. Most of the variables have default values assinged, but can be changed in the `.tf` file or overridden by using the `-var` flag with the `terraform apply` command. You will be prompted for any variable that does not have a default after running the `terraform apply` command.
2. Run `terrafom apply` in your console from the directory that that holds the `main.tf` and `variables.tf` file and provide any variables you are prompted for.
3. Review the deployment plan. If the terraform script and the provided variables validated successfully the deployment plan will be output in the consoled for you to review. Additionally you will be prompted wether you want to go ahead with the deployment. If everything looks ok, go ahead with `yes`. The deployment will now provision and configure all neccessary AWS services and start up FME Server. This will take about 10 - 20 minutes.
4. In this quickstart exmaple the terraform statefile `terraform.tfsate` will be created on on your local machine, so you can review the current state of your deployment and test the deployment. For any productive deployments it is highly recommended to not store the state file locally but in a remote location. This makes sure you can collaborate on the state and any sensitive data contained in the state file will only be accessible to authorized users. To use S3 as a backend for your statefile follow this documentation: [S3 terraform backend](https://www.terraform.io/language/settings/backends/s3)

### Test FME Server

Once the deployment is complete it is time to test FME Server. The public URL for the new FME Server can be found in the overview of the Application Gateway resource. Follow these steps to test FME Server:
1. [Log on to the Web User Interface](https://docs.safe.com/fme/html/FME_Server_Documentation/AdminGuide/Log-on-Get-Started-2-Tier.htm)
2. [Request and Install a License](https://docs.safe.com/fme/html/FME_Server_Documentation/AdminGuide/Request_and_Install_a_License-2-Tier.htm)
3. [Run Workspace](https://docs.safe.com/fme/html/FME_Server_Documentation/WebUI/Run-Workspace.htm?)

### Delete the deployment

To remove the FME Server deployment run `terrform destroy` in your console and confirm the prompt with `yes`.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29.6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/lb-services/alb/ | n/a |
| <a name="module_asg_core"></a> [asg\_core](#module\_asg\_core) | ./modules/asg/asg_core/ | n/a |
| <a name="module_asg_engine"></a> [asg\_engine](#module\_asg\_engine) | ./modules/asg/asg_engine/ | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database/ | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam/ | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network/ | n/a |
| <a name="module_nlb"></a> [nlb](#module\_nlb) | ./modules/lb-services/nlb/ | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_admin_pw"></a> [ad\_admin\_pw](#input\_ad\_admin\_pw) | Password of the admin user of the Active Directory service. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_ad_name"></a> [ad\_name](#input\_ad\_name) | Name of the Active Directory service | `string` | `"tf-fmeserver.safe"` | no |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the application load balancer | `string` | `"tf-application-lb"` | no |
| <a name="input_db_admin_pw"></a> [db\_admin\_pw](#input\_db\_admin\_pw) | Backend database admin pw. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_db_admin_user"></a> [db\_admin\_user](#input\_db\_admin\_user) | Backend database admin username. This variable should be retrieved from an [environment variable](https://www.terraform.io/cli/config/environment-variables#tf_var_name) or a secure secret store like [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret). DO NOT HARDCODE. | `string` | n/a | yes |
| <a name="input_fme_core_image_id"></a> [fme\_core\_image\_id](#input\_fme\_core\_image\_id) | Id of the FME Sever core image | `string` | `"ami-033c4d4d7d4b334ab"` | no |
| <a name="input_fme_engine_image_id"></a> [fme\_engine\_image\_id](#input\_fme\_engine\_image\_id) | Id of the FME Sever core image | `string` | `"ami-01bcc4b2970e7bead"` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | iam\_instance\_profile | `string` | `"test"` | no |
| <a name="input_igw_name"></a> [igw\_name](#input\_igw\_name) | Internet gateway name | `string` | `"tf-internet-gw"` | no |
| <a name="input_nat_name"></a> [nat\_name](#input\_nat\_name) | NAT gateway name | `string` | `"tf-nat-gw"` | no |
| <a name="input_nlb_name"></a> [nlb\_name](#input\_nlb\_name) | Name of the network load balancer | `string` | `"tf-network-lb"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Default value for onwer tag | `string` | `"gf"` | no |
| <a name="input_private_sn_name"></a> [private\_sn\_name](#input\_private\_sn\_name) | Backend virtual network subnet name | `string` | `"tf-private-subnet"` | no |
| <a name="input_public_sn_name"></a> [public\_sn\_name](#input\_public\_sn\_name) | Application gateway virtual network subnet name | `string` | `"tf-public-subnet"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Virtual private cloud name | `string` | `"tf-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | Public dns name of the application load balancer |
<!-- END_TF_DOCS --> 