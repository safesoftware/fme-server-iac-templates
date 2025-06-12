# packer scripts to create Azure Windows Images for a distributed FME Flow deployment
## How to use the scripts
### Prerequisites
1. [Install packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
2. [Authenticate to Azure](https://www.packer.io/plugins/builders/azure). In this example CLI authentication is used but there are also other options available depending on the use case.
3. For more details on the packer script review this [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer).
### Variables
|Parameter|Description|Usage example|
|---|---|---|
|`resource_group`|Set the Azure resource group in which the VM images are built and stored.|`-var 'resource_group=myImages-rg'`|
|`installer_url`|The installer URL needs to point to a FME Flow windows installer executable and can be obtained from [safe.com/downloads](safe.com/downloads).|`-var 'installer_url=https://downloads.safe.com/fme/2024/win64/fme-flow-2024.0.2.1-b24217-win-x64.exe'`|
|`tags`|At minimum it is recommended to set a Owner and fme_build tag, but additional tags can also be added via the tags variable.|`-var 'tags={Owner="QA",fme_build="22627"}'`|
### Create the Windows Images
1. Open a command line in the packer directory (directory with .pkr.hcl files)
2. Run `packer init fme_flow_az.pkr.hcl`
4. Open the `variables.pkrvars.hcl` file and update the placeholder text for the `resource_group`, FME `installer_url` and `tags` variables with the values for your deployment. 
3. Validate the script with set variables:
```
packer validate -var-file="variables.pkrvars.hcl" fme_flow_az.pkr.hcl
```
4. Build the images:
```
packer build -var-file="variables.pkrvars.hcl" fme_flow_az.pkr.hcl
```
### Modifying the Windows Images
To modify the Windows Images by installing additional 3rd party software or adding file packer provisioners, similar as used in this example for FME Flow, should be used. For more details please review this [documentation](https://www.packer.io/docs/provisioners).

### Remove VM images
To remove the Azure VM Images delete the resources in the resource group that was specified in the 'resource_group' parameter.