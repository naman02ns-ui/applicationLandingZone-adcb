# =============================================================================
# Function Apps Module
# =============================================================================

module "function_apps" {
  source = "./modules/app-service/app-function"

  for_each = var.function_apps

  resource_location                          = each.value.resource_location
  resource_group_name                       = each.value.resource_group_name
  application_name                          = each.value.application_name
  environment                               = each.value.environment
  service_plan_sku                          = "EP1"  # This will be overridden by existing_service_plan
  max_elastic_worker_count                  = 20
  existing_service_plan = {
    name                = module.app_service_plans[each.value.app_service_plan_name].name
    resource_group_name = each.value.resource_group_name
  }
  function_apps                             = each.value.function_apps
  app_function_subnet                       = each.value.app_function_subnet
  privatelink_subnet                        = each.value.privatelink_subnet
  privatelink_funcapp_subnet                = each.value.privatelink_funcapp_subnet
  private_dns_zone_id                       = each.value.private_dns_zone_id
  func_app_private_dns_zone_id              = each.value.func_app_private_dns_zone_id
  file_share_private_dns_zone_id            = each.value.file_share_private_dns_zone_id
  public_network_access_enabled             = each.value.public_network_access_enabled
  vnet_route_all_enabled                    = each.value.vnet_route_all_enabled
  application_insights_enabled              = each.value.application_insights_enabled
  application_insights_connection_string    = each.value.application_insights_connection_string
  application_insights_key                  = each.value.application_insights_key
  log_analytics_worksapce_id                = each.value.log_analytics_worksapce_id
  daily_memory_time_quota                   = each.value.daily_memory_time_quota
  customer_managed_key_enabled              = each.value.customer_managed_key_enabled
  kv_name                                   = each.value.kv_name
  kv_resource_group_name                    = each.value.kv_resource_group_name
  cmk_name                                  = each.value.cmk_name
  storage_use                               = each.value.storage_use
  sku_name                                  = each.value.sku_name
  create_fileshare                          = each.value.create_fileshare
  file_shares                               = each.value.file_shares
  function_app_key                          = each.key
  uai_name_override                         = "uai-${each.value.application_name}-${each.value.environment}-func-${each.key}"
  tags                                      = local.tags

  depends_on = [module.app_service_plans]
}

# =============================================================================
# RBAC Assignments
# =============================================================================

# Grant Function App's User-Assigned Managed Identity access to Key Vault
resource "azurerm_role_assignment" "function_app_kv_secrets_user" {
  for_each = {
    for fa_key, fa_config in var.function_apps : fa_key => {
      scope        = module.azure_key_vault.id
      principal_id = module.function_apps[fa_key].user_assigned_identity_principal_id
    }
    if module.function_apps[fa_key].user_assigned_identity_principal_id != null
  }

  scope                = each.value.scope
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value.principal_id
  description          = "Grant Function App ${each.key} access to Key Vault secrets"

  depends_on = [module.function_apps, module.azure_key_vault]
}

# Grant Function Apps access to Container Registry
resource "azurerm_role_assignment" "function_app_acr_pull" {
  for_each = {
    for fa_key, fa_config in var.function_apps :
    fa_key => {
      scope        = module.container_registries["aiapps-nonprod-acr"].acr_id
      principal_id = module.function_apps[fa_key].user_assigned_identity_principal_id
    }
    if module.function_apps[fa_key].user_assigned_identity_principal_id != null
  }

  scope                = each.value.scope
  role_definition_name = "AcrPull"
  principal_id         = each.value.principal_id
  description          = "Grant Function App access to Container Registry"

  depends_on = [module.container_registries, module.function_apps]
}