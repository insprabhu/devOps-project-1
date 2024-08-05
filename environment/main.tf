module "rgm" {
    source = "../resource group"
  rg-map = var.rg-map
}

module "stgm" {
    depends_on = [module.rgm]
    source = "../storage accouunt"
    stg-map = var.stg-map
}