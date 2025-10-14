data "azurerm_log_analytics_workspace" "workspace" {
  count               = var.ai_monitoring.enabled && var.ai_monitoring.log_analytics_ws  != null ? 1 : 0
  name                = try(var.ai_monitoring.log_analytics_ws.name, "")
  resource_group_name = try(var.ai_monitoring.log_analytics_ws.resource_group, "")
}