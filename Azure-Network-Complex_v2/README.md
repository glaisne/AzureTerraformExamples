# Notes
This network setup includes one /24 subnet and a collection of /28 subnets. The difference here, is that the /28s
are in two groups (Identified by name only). The trick here is to do one set of networks ("subnet-eng") then the 
next by using the sum() operator to continue on from the previous group.

  address_prefixes     = [cidrsubnet(var.SubnetResources["cidrPrefix"], var.SubnetResources["cidrsubnetNewbits"], sum([var.SubnetEngineering["Count"], count.index]))]


# For you
Specify the subscriptionId and TenantId on the commandline
```bash
terraform plan --var "SubscriptionId=11111111-1111-1111-1111-111111111111" --var "TenantId=11111111-1111-1111-1111-111111111111"

```

# Authenticating
This instance does not authenticate against Azure. The terminal used to run terraform needs to be authenticated ahead of time using
az login --use-device-code

after which, set the proper subscription:
az account set --subscription="<GUID>"

Confirm the current context:
az account list --query "[?isDefault]"

