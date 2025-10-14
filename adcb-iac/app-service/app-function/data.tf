data "azurerm_service_plan" "existing_service_plan" {
  count               = var.existing_service_plan != null ? 1 : 0
  name                = var.existing_service_plan.name
  resource_group_name = var.existing_service_plan.resource_group_name
}

data "azurerm_subnet" "app_service_subnet" {
  count                = var.app_function_subnet != null ? 1 : 0
  name                 = var.app_function_subnet.name
  virtual_network_name = var.app_function_subnet.vnet_name
  resource_group_name  = var.app_function_subnet.resource_group
}

data "azurerm_storage_account" "backup_sa" {
  count               = var.backup == null ? 0 : 1
  name                = try(var.backup.backup_sa.name, "")
  resource_group_name = try(var.backup.backup_sa.resource_group, "")
}

data "azurerm_log_analytics_workspace" "workspace" {
  count               = var.application_insights_enabled && var.log_analytics_ws != null ? 1 : 0
  name                = try(var.log_analytics_ws.name, "")
  resource_group_name = try(var.log_analytics_ws.resource_group, "")
}

data "azurerm_storage_account_blob_container_sas" "container_sas" {
  count             = var.backup == null ? 0 : 1
  connection_string = data.azurerm_storage_account.backup_sa[0].primary_connection_string
  container_name    = azurerm_storage_container.backup_container[0].name
  https_only        = true
  start             = "2024-01-23T12:20:23Z"
  expiry            = "2025-12-24T00:00:00Z"
  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

data "azurerm_subnet" "privatelink_subnet" {
  count                = var.privatelink_subnet != null ? 1 : 0
  name                 = var.privatelink_subnet.name
  virtual_network_name = var.privatelink_subnet.vnet_name
  resource_group_name  = var.privatelink_subnet.resource_group
}

data "azurerm_client_config" "current" {}

data "azurerm_subnet" "privatelink_funcapp_subnet" {
  count                = var.privatelink_funcapp_subnet != null ? 1 : 0
  name                 = var.privatelink_funcapp_subnet.name
  virtual_network_name = var.privatelink_funcapp_subnet.vnet_name
  resource_group_name  = var.privatelink_funcapp_subnet.resource_group
}