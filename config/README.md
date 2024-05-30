# Configuration scripts for distributed FME Flow VM images
These configuration scripts are used to create VM images that by installing a FME Core or FME Engine on a image and adding a config script that runs after the first startup to configure the new FME Flow VMs according to their environment. These scripts are added to VM images using packer. For more details check out the packer examples:

[Amazon Web Services packer example](https://github.com/safesoftware/fme-server-iac-templates/tree/main/AWS/packer)

[Microsoft Azure packer example](https://github.com/safesoftware/fme-server-iac-templates/tree/main/Azure/packer)

## Initiating the FME Flow configuration
The example deployment templates pass on the relevant parameters to the `config_fmeflow*` files to update the configuration of a VM to the respective environment. Before changing any of the config scripts make sure to review how the scripts are used in the deployment templates.
