variable "rg-map" {
type =  map(any) 
default = {
  rg1="West Europe"
}

}

variable "stg-map" {
    type = map(any)
    default = {
      stg1={
      name = "storage1"
      resource_group_name = "rg1"
      location= "eastus"
      account_tier = "Standard"
      account_replication_type="LRS"
      }
    }
    }
  
  variable "vm-map" {
    type = map(any)
    default = {
      vm1 = {
      vm_name = "webserver"
    nic_name  = "nic"
      ip_name   =   "web-ip"
      location = "West Europe"
      resource_group_name = "rg1"
      # network_interface_id = "webnic"
      
    }
    #   vm2={
    #   vm_name = "dataserver"
    #   nic_name  =   "data-nic"
    #   ip_name   =   "data-ip"
    #   location = "West Europe"
    #   resource_group_name = "rg1"
    # } }
   
    }
  }
  
  
#   variable "vnet-map" {
# type  = map(any)
# default = {
#  vnet_name = "West Europe"
# }
#   }

#   variable "public-ip" {
# type  = map(any)
# default = {
#  public_ip_name = "webserver" 
# }
#   }