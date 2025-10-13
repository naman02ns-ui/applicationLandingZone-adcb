module "cosmosdb" {
  source              = "../azure-terraform/modules/cosmosdb"
  application_name    = var.application_name
  environment         = var.environment
  resource_group_name = module.resource_group.rg_name
  databases           = var.databases
  tags                = local.tags
  private_dns_zone_id = data.azurerm_private_dns_zone.cosmos_dns_zone.id
  privatelink_subnet = {
    name           = module.base-infra.subnet_map[var.selected_subnet].name
    vnet_name      = module.base-infra.vnet_name
    resource_group = module.resource_group.rg_name
  }
  backup = {
    type                = "Periodic"
    interval_in_minutes = 60
    retention_in_hours  = 8
    storage_redundancy  = "Geo"
  }
  #identity_ids = azurerm_user_assigned_identity.cosmos-uai.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_connectivity_vnl" {
  provider              = azurerm.connectivity
  name                  = "${var.entity_name}-${var.environment}-vnl"
  resource_group_name   = "rg-connectivity-dns-uaenorth-01"
  private_dns_zone_name = data.azurerm_private_dns_zone.cosmos_dns_zone.name
  virtual_network_id    = module.base-infra.vnet_id
}
