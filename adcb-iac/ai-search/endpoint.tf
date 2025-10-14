resource "azurerm_private_endpoint" "ai_search_pep" {
  count               = var.privatelink_subnet != null ? 1 : 0
  name                = format("pe-aisrch-%s-%s", var.application_name, var.environment, local.location_shortcode)
  location            = local.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id
  tags                = local.tags

  private_service_connection {
    name                           = format("%s%s", azurerm_search_service.search_service.name, "-privatelink")
    private_connection_resource_id = azurerm_search_service.search_service.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink-aisrch-azure-net"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  depends_on = [azurerm_search_service.search_service]
}