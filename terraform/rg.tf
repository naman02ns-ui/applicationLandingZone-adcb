module "resource_group" {
  source  = "../azure-terraform/modules/resource-groups"
  rg_name = format("rg-%s-%s-%s-%s", var.application_name, var.environment, var.location, module.res-id.result)
  tags    = local.tags
}
