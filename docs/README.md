# Generate documentation for terraform modules
This script will run a terraform-docs command for each module that contains a ``main.tf`` file in the repository.

## How to use this script
### Update existing documentation after changing the terraform configuration
1. Set up terraform-docs: https://github.com/terraform-docs/terraform-docs
2. Run the script from the docs folder: ``./generate-tf-docs.sh``

In a CI/CD workflow the terraform-docs command can also be triggered by pull requests to the repository to keep the docs up to date after any of the terraform configurations have been modified. For more details review the terraform-docs repository.

### Create documention for a new terraform configuration
1. Create a ``README.md`` file next to the ``main.tf``
2. Add a Titel and any custom documentation
3. Add the following paragraph to automatically insert the terraform documentation the next time ``./generate-tf-docs.sh`` is run:
```
<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS --> 
```