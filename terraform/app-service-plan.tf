# =============================================================================
# App Service Plan Module
# =============================================================================

module "app_service_plans" {
  source = "../adcb-iac/app-service/app-service-plan"

  for_each = var.app_service_plans

  resource_location        = each.value.resource_location
  resource_group_name     = each.value.resource_group_name
  application_name        = each.value.application_name
  environment             = each.value.environment
  service_plan_sku        = each.value.service_plan_sku
  max_elastic_worker_count = each.value.max_elastic_worker_count
  worker_count            = each.value.worker_count
  os_type                 = each.value.os_type
  diagnostic_settings     = each.value.diagnostic_settings
  tags                    = local.tags
}