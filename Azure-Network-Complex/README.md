# Authenticating
This instance does not authenticate against Azure. The terminal used to run terraform needs to be authenticated ahead of time using
az login --use-device-code

after which, set the proper subscription:
az account set --subscription="<GUID>"

Confirm the current context:
az account list --query "[?isDefault]"

# Issues
* Seems to require importing of the resource group for some reason
  * terraform import azurerm_resource_group.resourceGroup /subscriptions/4ab0e1cd-ba91-4ed4-8ab9-37042f28cf7b/resourcegroups/TerraformVM