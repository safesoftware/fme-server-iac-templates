# IaC Templates to deploy FME Flow in the cloud
This repository is a collection of templates using different technologies to automatically provision cloud infrastructure and subsequently deploy FME Flow on the provisioned infrastructure. These examples can be used as boilerplate code for custom deployments, make it easier to implement a reliable and reproducible deployment and allows to integrate the deployment of FME Flow into existing CI/CD workflows.

## How to use this repository
This repo is structured by cloud service provider and technologies used. 
### VM Images
The central piece of the distributed FME Flow deployment are the VM images for the FME Flow Core and FME Flow Engine. For each cloud service provider examples on how to build these images with packer using the shared configuration scripts are provided.

### Deployment templates
Once the VM images are created they can be used as source images for the deployment. Alternatively any public source images provided by Safe Software can be used if available. The deployment templates implement a baseline of services needed for a distributed FME Flow deployment but are not production ready out of the box and should be customized to each environment and use case.

### Scaling Examples
The scaling examples showcase a proof of concept to scale CPU-Usage (Dynamic) FME Flow Engines based on queued jobs in Azure and AWS with python. These examples can be a starting point for an Azure Function and AWS Lambda implementation supporting different scaling scenarios.

### Previous versions of FME Flow
Over time as changes are made to FME Flow, these scripts and templates need to be updated. To deploy older versions of FME Flow, please use the scripts templates in the different branches. See this table below for which branch to use for each version of FME Flow:

| FME Flow Version | Git Branch |
| --------------- | --------------- |
| 2024.0+ | [main](https://github.com/safesoftware/fme-server-iac-templates/tree/main)  |
| 2023.X | [2023](https://github.com/safesoftware/fme-server-iac-templates/tree/2023)  |
| 2022.X | [2022](https://github.com/safesoftware/fme-server-iac-templates/tree/2022)  |

