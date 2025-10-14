module "base-infra" {
  source = "../adcb-iac/base-infrastructure"

  resource_group_name = module.resource_group.rg_name
  app_name            = var.application_name
  environment         = local.environment
  vnet_name           = "vnet-${var.application_name}-${var.environment}-uan"
  vnet_address_spaces = var.vnet_address_spaces
  subnets             = var.subnets

  connectivity_vnet_id = data.azurerm_virtual_network.connectivity_vnet.id

  tags = local.tags
}

