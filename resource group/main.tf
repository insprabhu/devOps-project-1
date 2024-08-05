resource "azurerm_resource_group" "kanha" {
for_each =  var.rg-map
name = each.key
location = each.value 
}