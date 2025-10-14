resource "azurerm_search_service" "search_service" {
  name                = var.search_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  replica_count       = var.replica_count
  partition_count     = var.partition_count

  allowed_ips                   = var.allowed_ips
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  dynamic "timeouts" {
    for_each = var.terraform_timeouts != null ? ["enabled"] : []
    content {
      create = var.terraform_timeouts.create
      read   = var.terraform_timeouts.read
      update = var.terraform_timeouts.update
      delete = var.terraform_timeouts.delete
    }
  }

  semantic_search_sku = var.semantic_search_sku

  local_authentication_enabled = var.local_authentication_enabled
  authentication_failure_mode  = !var.ad_authentication_enabled || (var.ad_authentication_enabled && !var.local_authentication_enabled) ? null : var.authentication_failure_mode

  tags = local.tags
}

#################### Diagnostic setting for AI Search monitoring #################

resource "azurerm_monitor_diagnostic_setting" "ai_search_diag" {
  count              = var.ai_monitoring.enabled ? 1 : 0
  name               = "ai-search-diag"
  target_resource_id = var.search_service_id

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.workspace[0].id

  enabled_metric {
    category = "AllMetrics"
  }

  enabled_log {
    category = "SearchServiceLogs"
  }
}