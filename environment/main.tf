module "rgm" {
    source = "../resource group"
  rg-map = var.rg-map
}

module "stgm" {
    depends_on = [module.rgm]
    source = "../storage accouunt"
    stg-map = var.stg-map
}

module "vm module" {
depends_on = [module.rgm]
source = "../virtual machine"
vm-map = var.vm-map
}