data "azurerm_log_analytics_workspace" "workspace" {
  count               = var.ai_monitoring.enabled && var.ai_monitoring.log_analytics_ws  != null ? 1 : 0
  name                = try(var.ai_monitoring.log_analytics_ws.name, "")
  resource_group_name = try(var.ai_monitoring.log_analytics_ws.resource_group, "")
}

data "azurerm_subnet" "privatelink_subnet" {
  count                = var.privatelink_subnet != null ? 1 : 0
  name                 = var.privatelink_subnet.name
  virtual_network_name = var.privatelink_subnet.vnet_name
  resource_group_name  = var.privatelink_subnet.resource_group
}