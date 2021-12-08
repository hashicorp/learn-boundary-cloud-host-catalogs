# Configure the Azure VM hosts
variable "instances" {
  default = [
    "boundary-vm-1", 
    "boundary-vm-2", 
    "boundary-vm-3", 
    "boundary-vm-4"
  ]
}

variable "vm_tags" {
  default = [
    {"service-type":"database", "application":"dev"},
    {"service-type":"database", "application":"dev"},
    {"service-type":"database", "application":"production"},
    {"service-type":"database", "application":"prod"}
  ]
}

resource "azurerm_virtual_network" "boundary-vm-test_group-vnet" {
  name                = "boundary-vm-test_group-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.boundary_rg.location
  resource_group_name = azurerm_resource_group.boundary_rg.name
}

resource "azurerm_subnet" "boundary_subnet" {
  name                 = "boundary_subnet"
  resource_group_name  = azurerm_resource_group.boundary_rg.name
  virtual_network_name = azurerm_virtual_network.boundary-vm-test_group-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  count               = length(var.instances)
  name                = "nic-${count.index+1}"
  location            = azurerm_resource_group.boundary_rg.location
  resource_group_name = azurerm_resource_group.boundary_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.boundary_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "boundary-vm" {
  count               = length(var.instances)
  name                = element(var.instances, count.index)
  resource_group_name = azurerm_resource_group.boundary_rg.name
  location            = azurerm_resource_group.boundary_rg.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  admin_password      = "SuperSecret123"
  disable_password_authentication = false
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  tags = var.vm_tags[count.index]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
}