# purpose
* Add a VM to an existing network and an existing Resource Group
  * All resources will be created in the same location as the resource group everything will go into.

# To use this, add the SubscriptionId and TenantId to the command line with:
 --var 'SubscriptionId=<SubscrpitionID>' and --var 'TenantId=<tenantId>'

Don't forget to update the variables in the terraform.tfvars to work with your environment.

# Authenticating
This instance does not authenticate against Azure. The terminal used to run terraform needs to be authenticated ahead of time using
az login --use-device-code

after which, set the proper subscription:
az account set --subscription="<GUID>"

Confirm the current context:
az account list --query "[?isDefault]"


# References:
https://stackoverflow.com/questions/52504137/terraform-azure-provision-vm-to-existing-subnet-vnet-resourcegroup