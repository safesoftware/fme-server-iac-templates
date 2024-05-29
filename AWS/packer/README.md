# packer scripts to create AMIs for a distributed FME Flow deployment
## How to use the scripts
### Prerequisites
1. [Install packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli?in=packer/aws-get-started)
2. [Authenticate to AWS](https://learn.hashicorp.com/tutorials/packer/aws-get-started-build-image?in=packer/aws-get-started#authenticate-to-aws)
3. Make sure there is a default VPC with a default subnet available in the region you want to create your AMI. Alternatively a VPC & a subnet ID can be specified in the run configuration. For more details review this [documentation](https://www.packer.io/plugins/builders/amazon/ebs) & [Tutorial](https://learn.hashicorp.com/tutorials/packer/aws-windows-image).
### Variables
|Parameter|Description|Usage example|
|---|---|---|
|`region`|Set the AWS region in which the AMI is built. After creating an AMI it can be moved to other regions.|`-var 'region=us-west-2'`|
|`installer_url`|The installer URL needs to point to a FME Flow windows installer executable and can be obtained from [safe.com/downloads](safe.com/downloads).|`-var 'installer_url=https://downloads.safe.com/fme/2024/win64/fme-flow-2024.0.2.1-b24217-win-x64.exe'`|
|`tags`|At minimum it is recommended to set a Owner and fme_build tag, but additional tags can also be added via the tags variable.|`-var 'tags={Owner="QA",fme_build="22627"}'`|
|`source_ami`|Set the source AMI for the building process. Microsoft Windows Server 2022 Base are recommended for FME Flow Core and Engine. Make sure the AMI is available in the AWS region.| `-var 'source_ami=ami-0174b6693aaeab3f6'`|
### Create the AMIs
1. Open a command line in the packer directory (directory with .pkr.hcl files)
2. Run `packer init`
3. Validate the script with set variables:
```
packer validate \
-var 'region=<REGION>' \
-var 'installer_url=<INSTALLER_URL>' \
-var 'tags={Owner="<OWNER",fme_build="<FME_BUILD>"}' \
fme_flow_aws.pkr.hcl
```
4. Build the images:
```
packer build \
-var 'region=<REGION>' \
-var 'installer_url=<INSTALLER_URL>' \
-var 'tags={Owner="<OWNER",fme_build="<FME_BUILD>"}' \
fme_flow_aws.pkr.hcl
```
### Modifying the AMIs
To modify the AMI by installing additional 3rd party software or adding file packer provisioners, similar as used in this example for FME Flow, should be used. For more details please review this [documentation](https://www.packer.io/docs/provisioners)

### Remove AMIs
To the the ec2 AMIs they need to be deregistered. For more details follow this documentation: [Deregister your AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/deregister-ami.htmls)
 

