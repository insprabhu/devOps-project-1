# creation of vertual network group#
resource "azurerm_virtual_network" "vm" {
    for_each = var.vm-map
  name = each.value.name
  address_space       = ["10.0.0.0/16"]
  location            = each.value.rg-map.location
  resource_group_name = each.key.rg-map.name
}

# creation of subnet #
resource "azurerm_subnet" "vm" {
  name                 = "internal"
  resource_group_name  = each.key.rg-map.name
  virtual_network_name = azurerm_virtual_network.vm.name
  address_prefixes     = ["10.0.2.0/24"]
}

# creation of network interface #
resource "azurerm_network_interface" "vm" {
  name                = each.value.nic_name
  location            = each.value.rg-map.location
  resource_group_name = each.key.rg-map.name
for_each = var.vm-map
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm[each.key].id
      }
}

# creation of network security #
resource "azurerm_network_security_group" "vm" {
  name                = "patanjali"
  location            = each.value.rg-map.location
  resource_group_name = each.key.rg-map.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "23", "24"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}
}

# creation of public ip #

resource "azurerm_public_ip" "vm" {
  name                = each.value.ip_name
  resource_group_name = each.key.rg-map.name
  location            = each.value.rg-map.location
  allocation_method   = "Static"
  for_each = var.vm-map

}
# creation of az_n/w_interface_security_group_association #
resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.vm[each.key].id
  network_security_group_id = azurerm_network_security_group.vm.id
  for_each = var.vm-map
 
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = each.value.vm_name
  resource_group_name = each.key.rg-map.name
  location            = each.value.rg-map.location
  size                = "Standard_F2"
  for_each = var.vm-map
  computer_name = "host-${each.value.vm_name}"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.vm[each.key].id,
    
  ]

  os_disk {
    name = "osdisk-${each.value.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}