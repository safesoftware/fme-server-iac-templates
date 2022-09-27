# Configuration scripts for distributed FME Server VM images
These configuration scripts are used to create VM images that by installing a FME Core or FME Engine on a image and adding a config script that runs after the first startup to configure the new FME Server VMs according to their environment.
## Initiating the FME Server configuration
The example deployment templates pass on the relevant parameters to the `config_fmeserver*` files to update the configuration of a VM to the respective environment. Before changing any of the config scripts make sure to review how the scripts used in the deployment templates.
