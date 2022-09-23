# packer scripts to create Azure Windows Images for a distributed FME Server deployment
## How to use the scripts
### Prerequisites
1. [Install packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
2. [Authenticate to Azure](https://www.packer.io/plugins/builders/azure). In this example CLI authentication is used but there are also other options available depending on the use case.
3. For more details on the packer script review this [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer).
### Create the AMIs
1. Open a command line in the packer directory (directory with .pkr.hcl files)
2. Run `packer init`
3. Run `packer validate fme_core.pkr.hcl`
4. Run `packer build -var 'installer_url=<FME_SERVER_INSTALLER_URL>' fme_core.pkr.hcl` (If the `installer_url` variable is not set, the default value specified in the `.hcl` file will be used.)
5. Repeat step 3 and 4 with 3. Run `fme_engine.pkr.hcl`
### Modifying the Windows Images
To modify the Windows Images by installing additional 3rd party software or adding file packer provisioners, similar as used in this example for FME Server, should be used. For more details please review this [documentation](https://www.packer.io/docs/provisioners).