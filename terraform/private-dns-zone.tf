resource "azurerm_private_dns_zone_virtual_network_link" "aiappsnonprod-privatelink_sql_dns" {
  provider              = azurerm.connectivity
  name                  = "${var.application_name}-${var.environment}-vnl"
  resource_group_name   = var.connectivity_dns_zone_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.privatelink_sql.name
  virtual_network_id    = module.base-infra.vnet_id
}
