subscriptionId = ""
tenantId       = ""

resourceGroupName = "ComplexNetworkv2"
location          = "East US 2"

VNetAddressSpace = "10.216.0.0/23"
VNetName = "vnet-ComplexNetworkv2-01"

SubnetQA = {
  Name = "Subnet-QA"
  Count = 1
  cidrsubnetNewbits = 1
}

SubnetEngineering = {
  Name = "Subnet-Eng"
  Count = 14
  cidrPrefix = "10.216.1.0/24"
  cidrsubnetNewbits = 4
}

SubnetResources = {
  Name = "Subnet-Resources"
  Count = 2
  cidrPrefix = "10.216.1.0/24"
  cidrsubnetNewbits = 4
}
