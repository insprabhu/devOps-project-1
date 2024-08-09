variable "vm-map" {
    type = map(any)
    # default = {
    #   vm1 = {
    #   vm_name = "webserver"
    #   nic_name  =   "web-nic"
    #   ip_name   =   "web-ip"
    

    # }
    # vm2 = {
    #   vm_name = "dataserver"
    #   nic_name  =   "app-nic"
    #   ip_name   =   "app-ip"
    # }
    # }
  
}
variable "rg-map" {
type    =   map(any)
}