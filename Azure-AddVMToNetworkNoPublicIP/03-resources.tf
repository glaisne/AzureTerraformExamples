variable "resourceGroupName" {}
variable vnetName {}
variable subnetName {}
variable vmName {}


data "azurerm_resource_group" "resourceGroup" {
  name     = var.resourceGroupName
}

data "azurerm_subnet" "subnet" {
  name = var.subnetName
  virtual_network_name = var.vnetName
  resource_group_name = var.resourceGroupName
}


resource "azurerm_network_interface" "Nic01" {
  name                = "${var.vmName}-Nic"
  location            = "${data.azurerm_resource_group.resourceGroup.location}"
  resource_group_name = var.resourceGroupName

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "Server" {
  name                = var.vmName
  resource_group_name = var.resourceGroupName
  location            = "${data.azurerm_resource_group.resourceGroup.location}"
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

  depends_on = [azurerm_network_interface.Nic01]
}