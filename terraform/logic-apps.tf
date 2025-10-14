# =============================================================================
# Logic Apps Module
# =============================================================================

module "logic_apps" {
  source = "../../IaC-ADCBModules/app-service/logic-app"

  for_each = var.logic_apps

  resource_location                    = each.value.resource_location
  resource_group_name                 = each.value.resource_group_name
  application_name                    = each.value.application_name
  environment                         = each.value.environment
  storage_account_name               = each.value.storage_account_name
  service_plan_name                   = each.value.service_plan_name
  existing_service_plan              = module.app_service_plans[each.value.app_service_plan_name].id
  user_assigned_identity_ids          = each.value.user_assigned_identity_ids
  privatelink_subnet                  = each.value.privatelink_subnet
  private_dns_zone_id                = each.value.private_dns_zone_id
  sku_name                           = each.value.sku_name
  file_shares                        = each.value.file_shares
  customer_managed_key_enabled       = each.value.customer_managed_key_enabled
  kv_name                            = each.value.kv_name
  kv_resource_group_name             = each.value.kv_resource_group_name
  cmk_name                           = each.value.cmk_name
  storage_use                        = each.value.storage_use
  definistion_file_path              = each.value.definistion_file_path
  file_share_private_dns_zone_id     = each.value.file_share_private_dns_zone_id
  create_fileshare                   = each.value.create_fileshare
  uai_required                       = each.value.uai_required
  logic_apps                         = { for k, v in each.value.logic_apps : k => v }
  tags                               = local.tags

  depends_on = [module.app_service_plans]
}

# Grant Logic App's User-Assigned Managed Identity access to Key Vault
resource "azurerm_role_assignment" "logic_app_kv_secrets_user" {
  for_each = {
    for la_key, la_config in var.logic_apps : la_key => la_config
    if module.logic_apps[la_key].user_assigned_identity_principal_id != null
  }

  scope                = module.azure_key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.logic_apps[each.key].user_assigned_identity_principal_id
  description          = "Grant Logic App ${each.key} access to Key Vault"

  depends_on = [module.azure_key_vault, module.logic_apps]
}

# Grant Logic Apps access to Cosmos DB
resource "azurerm_role_assignment" "logic_app_cosmosdb_contributor" {
  for_each = {
    for la_key, la_config in var.logic_apps : la_key => {
      scope        = "/subscriptions/${var.management_sub_id}/resourceGroups/${module.resource_group.rg_name}/providers/Microsoft.DocumentDB/databaseAccounts/*"
      principal_id = module.logic_apps[la_key].user_assigned_identity_principal_id
    } if module.logic_apps[la_key].user_assigned_identity_principal_id != null
  }

  scope                = each.value.scope
  role_definition_name = "Cosmos DB Built-in Data Contributor"
  principal_id         = each.value.principal_id
  description          = "Grant Logic App ${each.key} access to Cosmos DB"

  depends_on = [module.logic_apps]
}

# Grant Logic Apps access to Storage Account
resource "azurerm_role_assignment" "logic_app_storage_blob_contributor" {
  for_each = {
    for la_key, la_config in var.logic_apps : la_key => {
      scope        = "/subscriptions/${var.management_sub_id}/resourceGroups/${module.resource_group.rg_name}/providers/Microsoft.Storage/storageAccounts/*"
      principal_id = module.logic_apps[la_key].user_assigned_identity_principal_id
    } if module.logic_apps[la_key].user_assigned_identity_principal_id != null
  }

  scope                = each.value.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value.principal_id
  description          = "Grant Logic App ${each.key} access to Storage Account"

  depends_on = [module.logic_apps]
}