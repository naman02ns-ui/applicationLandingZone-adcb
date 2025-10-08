# =============================================================================
# Data Sources for Existing Azure Resources
# =============================================================================

# Existing Key Vault
data "azurerm_key_vault" "existing" {
  for_each = var.enable_existing_key_vaults > 0 ? var.existing_key_vaults : {}

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Existing Storage Account
data "azurerm_storage_account" "existing" {
  for_each = var.enable_existing_storage_accounts > 0 ? var.existing_storage_accounts : {}

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Existing AI Search Service
data "azurerm_search_service" "existing" {
  for_each = var.enable_existing_ai_search_services > 0 ? var.existing_ai_search_services : {}

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Existing Log Analytics Workspace
data "azurerm_log_analytics_workspace" "existing" {
  for_each = var.enable_existing_log_analytics_workspaces > 0 ? var.existing_log_analytics_workspaces : {}

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Existing Cosmos DB Account
data "azurerm_cosmosdb_account" "existing" {
  for_each = var.enable_existing_cosmos_db > 0 ? var.existing_cosmos_db_accounts : {}

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}