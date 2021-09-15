variable "resourceGroupName" {}
variable "location" {}
variable "VNetName" {}
variable "VNetAddressSpace" {}
variable "SubnetQA" {}
variable "SubnetEngineering" {}
variable "SubnetResources" {}

resource "azurerm_resource_group" "resourceGroup" {
  name     = var.resourceGroupName
  location = var.location
}

resource "azurerm_virtual_network" "vnet01" {
  name                = var.VNetName
  resource_group_name = var.resourceGroupName
  address_space       = ["${var.VNetAddressSpace}"]
  location            = var.location

  depends_on = [azurerm_resource_group.resourceGroup]
}

resource "azurerm_subnet" "SubnetQA" {
  count                = var.SubnetQA["Count"]
  name                 = var.SubnetQA["Name"]
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = [cidrsubnet(var.VNetAddressSpace, var.SubnetQA["cidrsubnetNewbits"], count.index)]

  depends_on = [azurerm_virtual_network.vnet01]
}


resource "azurerm_subnet" "Engineering" {
  count                = var.SubnetEngineering["Count"]
  name                 = join("-", [var.SubnetEngineering["Name"], count.index])
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = [cidrsubnet(var.SubnetEngineering["cidrPrefix"], var.SubnetEngineering["cidrsubnetNewbits"], count.index)]

  depends_on = [azurerm_virtual_network.vnet01]
}


resource "azurerm_subnet" "SubnetResources" {
  count                = var.SubnetResources["Count"]
  name                 = join("-", [var.SubnetResources["Name"], count.index])
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = [cidrsubnet(var.SubnetResources["cidrPrefix"], var.SubnetResources["cidrsubnetNewbits"], sum([var.SubnetEngineering["Count"], count.index]))]

  depends_on = [azurerm_virtual_network.vnet01]
}

