module "resource_group" {
  source   = "../adcb-iac/resource-group"
  rg_name  = format("rg-%s-%s-%s-%s", var.application_name, var.environment, var.location, module.res-id.result)
  location = var.location
  tags     = local.tags
}
