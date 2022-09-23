# packer scripts to create AMIs for a distributed FME Server deployment
## How to use the scripts
### Prerequisites
1. [Install packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli?in=packer/aws-get-started)
2. [Authenticate to AWS](https://learn.hashicorp.com/tutorials/packer/aws-get-started-build-image?in=packer/aws-get-started#authenticate-to-aws)
3. Make sure there is a default VPC with a default subnet available in the region you want to create your AMI. Alternatively a VPC & a subnet ID can be specified in the run configuration. For more details review this [documentation](https://www.packer.io/plugins/builders/amazon/ebs) & [Tutorial](https://learn.hashicorp.com/tutorials/packer/aws-windows-image).
### Create the AMIs
1. Open a command line in the packer directory (directory with .pkr.hcl files)
2. Run `packer init`
3. Run `packer validate fme_core.pkr.hcl`
4. Run `packer build -var 'installer_url=<FME_SERVER_INSTALLER_URL>' fme_core.pkr.hcl` (If the `installer_url` variable is not set, the default value specified in the `.hcl` file will be used.)
5. Repeat step 3 and 4 with 3. Run `fme_engine.pkr.hcl`
 
### Modifying the AMIs
To modify the AMI by installing additional 3rd party software or adding file packer provisioners, similar as used in this example for FME Server, should be used. For more details please review this [documentation](https://www.packer.io/docs/provisioners)
 

