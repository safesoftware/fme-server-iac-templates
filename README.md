# Templates to deploy FME Server in the cloud
This repository is a collection of templates using different technologies to automatically provision cloud infrastructure and subsequently deploy FME Server on the provisioned infrastructure. These examples can be used as boilerplate code for custom deployments, make it easier to implement a reliable and reproducible deployment and allows to integrate the deployment of FME Sever into existing CI/CD workflows.

## How to use this repository
This repo is structured by cloud service provider and technologies used. 
### VM Images
The central piece of the distributed FME Server deployment are the VM images for the FME Core and FME Engine. For each cloud service provider examples on how to build these images with packer using the shared configuration scripts are provided.

### Deployment templates
Once the VM images are created they can be used as source images for the deployment. Alternatively any public source images provided by Safe Software can be used if available. The deployment templates implement a baseline of services needed for a distributed FME Server deployment but are not production ready out of the box and should be customized to each environment and use case.