subscriptionId = ""
tenantId       = ""

resourceGroupName = "ComplexNetwork-rg"
location          = "East US 2"

VNetAddressSpace = "10.216.0.0/16"
VNetName = "vnet01"

SubnetQA = {
  Name = "Subnet-QA"
  Count = 1
  cidrsubnetNewbits = 7
}

SubnetEngineering = {
  Name = "Subnet-Eng"
  Count = 10
  cidrPrefix = "10.216.2.0/24"
  cidrsubnetNewbits = 4
}

SubnetResources = {
  Name = "Subnet-Resources"
  Count = 2
  cidrPrefix = "10.216.4.0/24"
  cidrsubnetNewbits = 4
}
