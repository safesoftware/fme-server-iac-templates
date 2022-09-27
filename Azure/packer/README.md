# packer scripts to create Azure Windows Images for a distributed FME Server deployment
## How to use the scripts
### Prerequisites
1. [Install packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
2. [Authenticate to Azure](https://www.packer.io/plugins/builders/azure). In this example CLI authentication is used but there are also other options available depending on the use case.
3. For more details on the packer script review this [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer).
### Variables
|Parameter|Description|
|---|---|
|`installer_url`|The installer URL needs to point to a FME Server windows installer executable and can be obtained from [safe.com/downloads](safe.com/downloads).|
|`tags`|At minimum it is recommended to set a Owner and fme_build tag, but additional tags can also be added via the tags variable.|
### Create the AMIs
1. Open a command line in the packer directory (directory with .pkr.hcl files)
2. Run `packer init`
3. Validate the script with set variables:
```
packer validate \
-var 'installer_url=<INSTALLER_URL>' \
-var 'tags={Owner="<OWNER>",fme_build="<FME_BUILD>"}' \
fme_server_az.pkr.hcl
```
4. Build the images:
```
packer build \
-var 'installer_url=<INSTALLER_URL>' \
-var 'tags={Owner="<OWNER>",fme_build="<FME_BUILD>"}' \
fme_server_az.pkr.hcl
```
5. Repeat step 3 and 4 with 3. Run `fme_engine.pkr.hcl`
### Modifying the Windows Images
To modify the Windows Images by installing additional 3rd party software or adding file packer provisioners, similar as used in this example for FME Server, should be used. For more details please review this [documentation](https://www.packer.io/docs/provisioners).