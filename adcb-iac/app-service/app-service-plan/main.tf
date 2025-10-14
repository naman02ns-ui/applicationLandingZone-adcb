module "res-id" {
  source = "../../utility/random-identifier"
}

resource "azurerm_service_plan" "sp" {
  location                     = local.location
  name                         = format("asp-%s-%s-%s-%s", var.application_name, var.environment, local.location_shortcode, module.res-id.result)
  os_type                      = var.os_type
  resource_group_name          = local.rg
  sku_name                     = var.service_plan_sku
  maximum_elastic_worker_count = var.max_elastic_worker_count
  worker_count                 = var.worker_count

  tags = merge(local.tags, local.common_tags, { "resource_type" = "service-plan" })
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-app-svc-${var.environment}"
  target_resource_id             = azurerm_service_plan.sp.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "metric" {
    for_each = each.value.metric_categories
    content {
      category = metric.value
    }
  }
}











