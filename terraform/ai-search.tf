module "ai-search" {
  source              = "../azure-terraform/modules/ai-search"
  resource_group_name = module.resource_group.rg_name
  replica_count       = var.replica_count
  
  environment         = var.environment
  application_name    = var.application_name
  tags                = local.tags
  #search_service_id  = module.ai-search.search_service_id
  private_dns_zone_id = data.azurerm_private_dns_zone.aisrch_dns_zone.id
}

/*
resource "azurerm_private_dns_zone_virtual_network_link" "aisrch-connectivity-to-ailighthouse-vnl" {
  provider              = azurerm.connectivity
  name                  = "ailighthouse-${var.environment}-vnl"
  resource_group_name   = "rg-connectivity-dns-uaenorth-01"
  private_dns_zone_name = data.azurerm_private_dns_zone.aisrch_dns_zone.name
  virtual_network_id    = module.base-infra.vnet_id
}
*/
