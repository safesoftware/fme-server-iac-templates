# Issue retrieving secrets from modules
With Bicep it is highly discouraged to use secrets in outputs of modules: [Manage Secrects by using Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-secrets)

Therefore it is currently not possible to pass secrets between modules and a main Bicep script, except for using a Key Vault as a workaround or defining a existing storage creating a implicit dependency. The issue is described in detail here: [Recommended approach for outputting/getting secrets](https://github.com/Azure/bicep/discussions/6173)

The FME Server deployment relies on that functionality because the PowerShell script setting up FME Server after the deployment requires the storage account key. Because of this the storage might still remain in the main.bicep file and only resources that do not have to output secrets are defined in modules. 
