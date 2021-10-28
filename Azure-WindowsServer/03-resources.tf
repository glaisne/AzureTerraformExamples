variable "resourceGroupName" {}
variable "location" {}
variable "vnetName" {}}
variable "vnet01AddressSpace" {}}
variable "vmName" {}}

data "http" "myExtIp" {
  url = "http://ident.me/"
}

resource "azurerm_resource_group" "resourceGroup" {
  name     = var.resourceGroupName
  location = var.location
}

resource "azurerm_virtual_network" "vnet01" {
  name                = var.vnetName
  resource_group_name = var.resourceGroupName
  address_space       = ["${var.vnet01AddressSpace}"]
  location            = var.location

  depends_on = [azurerm_resource_group.resourceGroup]
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = [cidrsubnet(var.vnet01AddressSpace, 8, 1)]

  depends_on = [azurerm_virtual_network.vnet01]
}

resource "azurerm_network_security_group" "securityGroup" {
  name                = "${var.vnetName}-sg"
  resource_group_name = var.resourceGroupName
  location            = var.location

  security_rule {
    name                       = "MyRDPIn"
    description                = "Allow my external IP in to 3389"
    protocol                   = "tcp"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = data.http.myExtIp.body
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_virtual_network.vnet01]
}

resource "azurerm_subnet_network_security_group_association" "subnetSGAssociation01" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.securityGroup.id

  depends_on = [azurerm_subnet.default, azurerm_network_security_group.securityGroup]
}

resource "azurerm_network_interface" "Nic01" {
  name                = "${var.vmName}-Nic"
  location            = var.location
  resource_group_name = var.resourceGroupName

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip01.id
  }

  depends_on = [azurerm_virtual_network.vnet01, azurerm_public_ip.pip01]
}

resource "azurerm_public_ip" "pip01" {
  name                = "${var.vmName}-pip"
  resource_group_name = var.resourceGroupName
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_windows_virtual_machine" "Server" {
  name                = var.vmName
  resource_group_name = var.resourceGroupName
  location            = var.location
  size                = "Standard_A2"
  admin_username      = "gene"
  admin_password      = "Password!101"
  network_interface_ids = [
    azurerm_network_interface.Nic01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [azurerm_virtual_network.vnet01, azurerm_network_interface.Nic01]
}