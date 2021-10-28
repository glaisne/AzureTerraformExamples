# purpose
* Create a VM and VNet in Azure

# Authenticating
This instance does not authenticate against Azure. The terminal used to run terraform needs to be authenticated ahead of time using
az login --use-device-code

after which, set the proper subscription:
az account set --subscription="<GUID>"

Confirm the current context:
az account list --query "[?isDefault]"

# To use this, add the SubscriptionId and TenantId to the command line with:
 --var 'SubscriptionId=<SubscrpitionID>' and --var 'TenantId=<tenantId>'

Don't forget to update the variables in the terraform.tfvars to work with your environment.


# Known Issues
