# =============================================================================
# Function Apps Module
# =============================================================================

module "function_apps" {
  source = "../app-service/app-function"

  for_each = var.enable_function_apps > 0 ? var.function_apps : {}

  resource_location                          = each.value.resource_location
  resource_group_name                       = each.value.resource_group_name
  application_name                          = each.value.application_name
  environment                               = each.value.environment
  service_plan_sku                          = each.value.service_plan_sku
  max_elastic_worker_count                  = each.value.max_elastic_worker_count
  existing_service_plan                     = each.value.existing_service_plan
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
  tags                                      = each.value.tags
}

# Grant Function App's User-Assigned Managed Identity access to existing Key Vault
resource "azurerm_role_assignment" "function_app_kv_secrets_user" {
  for_each = {
    for combo in flatten([
      for kv_key, kv_config in (var.enable_existing_key_vaults > 0 && var.enable_function_apps > 0) ? var.existing_key_vaults : {} : [
        for fa_key, fa_config in var.function_apps : {
          kv_key = kv_key
          fa_key = fa_key
          kv_id  = data.azurerm_key_vault.existing[kv_key].id
          principal_id = module.function_apps[fa_key].user_assigned_identity_principal_id
        }
      ]
    ]) : "${combo.kv_key}-${combo.fa_key}" => combo
  }

  scope                = each.value.kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value.principal_id
  description          = "Grant Function App ${each.value.fa_key} access to existing Key Vault ${each.value.kv_key}"

  depends_on = [data.azurerm_key_vault.existing, module.function_apps]
}

# Grant Function App's User-Assigned Managed Identity access to Container Registry
resource "azurerm_role_assignment" "function_app_acr_pull" {
  for_each = {
    for combo in flatten([
      for acr_key, acr_config in (var.enable_container_registries > 0 && var.enable_function_apps > 0) ? var.container_registries : {} : [
        for fa_key, fa_config in var.function_apps : {
          acr_key = acr_key
          fa_key = fa_key
          acr_id  = module.container_registries[acr_key].acr_id
          principal_id = module.function_apps[fa_key].user_assigned_identity_principal_id
        }
      ]
    ]) : "${combo.acr_key}-${combo.fa_key}" => combo
  }

  scope                = each.value.acr_id
  role_definition_name = "AcrPull"
  principal_id         = each.value.principal_id
  description          = "Grant Function App ${each.value.fa_key} pull access to Container Registry ${each.value.acr_key}"

  depends_on = [module.container_registries, module.function_apps]
}