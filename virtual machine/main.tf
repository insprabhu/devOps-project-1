# creation of vertual network group#
resource "azurerm_virtual_network" "vnet" { 
  for_each = var.rg-map
  name = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = each.value
  resource_group_name = each.key
}

# creation of subnet #
resource "azurerm_subnet" "sub" {
  
  name                 = "internal"
   for_each = var.rg-map
  resource_group_name  = each.key
  virtual_network_name = "vnet"
  address_prefixes     = ["10.0.2.0/24"]

}

# # creation of network interface #
resource "azurerm_network_interface" "nic" {
  for_each = var.rg-map
  name                = "nic"
  location            = each.value
  resource_group_name = each.key

  ip_configuration {
    name                          = "internal"
    subnet_id                     = [azurerm_subnet.sub[each.key].id]
    private_ip_address_allocation = "Dynamic"
  
    }
}



resource "azurerm_public_ip" "public-ip" {
  for_each = var.rg-map
  name                = "pub-ip"
  resource_group_name = each.key
  location            = each.value
  allocation_method   = "Static"
  
}


resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vm-map
  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = "Standard_F2"
  
  computer_name = "host-${each.value.vm_name}"
  admin_username      = "adminuser"
  admin_password      = "Prabhu@12345"
  network_interface_ids = [azurerm_network_interface.nic["rg1"].id]

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

# # creation of az_n/w_interface_security_group_association #
# resource "azurerm_network_interface_security_group_association" "vm" {
#   network_interface_id      = azurerm_network_interface.vm[each.key].id
#   network_security_group_id = azurerm_network_security_group.vm.id
#   for_each = var.vm-map
 
# }

# # creation of network security #
# resource "azurerm_network_security_group" "vm" {
#   name                = "patanjali"
#   location            = each.value.rg-map.location
#   resource_group_name = each.key.rg-map.name

#   security_rule {
#     name                       = "test123"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_ranges    = ["22", "23", "24"]
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
# }
# }

# # creation of public ip #