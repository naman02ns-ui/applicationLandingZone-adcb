module "key_vaults" {
  source = "../kv"

  for_each = var.key_vaults

  resource_location              = each.value.resource_location
  resource_group_name           = each.value.resource_group_name
  application_name              = each.value.application_name
  environment                   = each.value.environment
  enabled_for_deployment        = each.value.enabled_for_deployment
  enabled_for_disk_encryption   = each.value.enabled_for_disk_encryption
  purge_protection_enabled      = each.value.purge_protection_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  rbac_authorization_enabled    = each.value.rbac_authorization_enabled
  sku_name                      = each.value.sku_name
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  network_acls                  = each.value.network_acls
  role_assignments              = each.value.role_assignments
  owners                        = each.value.owners
  lock                          = each.value.lock
  diagnostic_settings           = each.value.diagnostic_settings
  private_dns_zone_name         = each.value.private_dns_zone_name
  privatelink_subnet            = each.value.privatelink_subnet
  tags                          = each.value.tags
  private_dns_zone_id           = each.value.private_dns_zone_id
}

module "function_apps" {
  source = "../app-service/app-function"

  for_each = var.function_apps

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
  site_config                               = each.value.site_config
  connection_strings                        = each.value.connection_strings
  backup                                    = each.value.backup
  artifact_url                              = each.value.artifact_url
  tags                                      = each.value.tags
}

module "container_registries" {
  source = "../container-registry"

  for_each = var.container_registries

  resource_location               = each.value.resource_location
  resource_group_name            = each.value.resource_group_name
  application_name               = each.value.application_name
  environment                    = each.value.environment
  zone_redundancy_enabled        = each.value.zone_redundancy_enabled
  key_expiration_date           = each.value.key_expiration_date
  sku                           = each.value.sku
  azurerm_key_vault_key         = each.value.azurerm_key_vault_key
  kv_name                       = each.value.kv_name
  admin_enabled                 = each.value.admin_enabled
  georeplication_locations      = each.value.georeplication_locations
  images_retention_enabled      = each.value.images_retention_enabled
  images_retention_days         = each.value.images_retention_days
  retention_policy_in_days      = each.value.retention_policy_in_days
  azure_services_bypass_allowed = each.value.azure_services_bypass_allowed
  trust_policy_enabled          = each.value.trust_policy_enabled
  allowed_cidrs                 = each.value.allowed_cidrs
  allowed_subnets               = each.value.allowed_subnets
  public_network_access_enabled = each.value.public_network_access_enabled
  data_endpoint_enabled         = each.value.data_endpoint_enabled
  encryption_enabled            = each.value.encryption_enabled
  privatelink_subnet            = each.value.privatelink_subnet
  private_dns_zone_id          = each.value.private_dns_zone_id
  role_assignments             = each.value.role_assignments
  tags                          = each.value.tags
}

module "container_app_environments" {
  source = "../container-services/container-app-environment"

  for_each = var.container_app_environments

  management_sub_id           = each.value.management_sub_id
  resource_location          = each.value.resource_location
  resource_group_name        = each.value.resource_group_name
  application_name           = each.value.application_name
  environment               = each.value.environment
  subnet                    = each.value.subnet
  workload_profile          = each.value.workload_profile
  log_analytics_workspace_id = each.value.log_analytics_workspace_id
  tags                      = each.value.tags
}

module "container_apps" {
  source = "../container-services/container-app"

  for_each = var.container_apps

  resource_location             = each.value.resource_location
  resource_group_name          = each.value.resource_group_name
  application_name             = each.value.application_name
  environment                  = each.value.environment
  tags                        = each.value.tags
  registry                    = each.value.registry
  container_app_environment_id = module.container_app_environments[each.value.container_app_environment_key].container_app_env_id
  ingress_external_enabled     = each.value.ingress_external_enabled
  ingress_target_port         = each.value.ingress_target_port
  ingress_transport           = each.value.ingress_transport
  environment_variables       = each.value.environment_variables
  workload_profile_name       = each.value.workload_profile_name
  container_config            = each.value.container_config
  revision_mode               = each.value.revision_mode
  external_identity_ids       = each.value.external_identity_ids

  depends_on = [module.container_app_environments, module.container_registries]
}

module "ai_search_services" {
  source = "../AI-Search"

  for_each = var.ai_search_services

  resource_group_name    = each.value.resource_group_name
  location              = each.value.location
  application_name      = each.value.application_name
  environment           = each.value.environment
  location_shortcode    = each.value.location_shortcode
  sku                   = each.value.sku
  partition_count       = each.value.partition_count
  replica_count         = each.value.replica_count
  hosting_mode          = each.value.hosting_mode
  public_network_access_enabled = each.value.public_network_access_enabled
  allowed_ips           = each.value.allowed_ips
  authentication_failure_mode = each.value.authentication_failure_mode
  customer_managed_key_enforcement_enabled = each.value.customer_managed_key_enforcement_enabled
  enable_system_assigned_identity = each.value.enable_system_assigned_identity

  # Private Endpoint Configuration (enabled by default)
  private_endpoint_enabled = each.value.private_endpoint_enabled
  private_endpoint_subnet_name = each.value.private_endpoint_subnet_name
  virtual_network_name = each.value.virtual_network_name
  network_resource_group_name = each.value.network_resource_group_name
  private_dns_zone_id = each.value.private_dns_zone_id

  # Monitoring Configuration (enabled by default)
  log_analytics_workspace_id = each.value.log_analytics_workspace_id
  diagnostic_logs_retention_days = each.value.diagnostic_logs_retention_days
  diagnostic_metrics_retention_days = each.value.diagnostic_metrics_retention_days

  # RBAC Configuration
  contributor_principal_ids = each.value.contributor_principal_ids
  index_data_contributor_principal_ids = each.value.index_data_contributor_principal_ids
  index_data_reader_principal_ids = each.value.index_data_reader_principal_ids

  # Tagging
  tags = each.value.tags
  cost_center = each.value.cost_center
  owner = each.value.owner
  project = each.value.project
}

# ========================================
# Cosmos DB Module
# ========================================
module "cosmos_db" {
  for_each = var.cosmos_db_services

  source = "../cosmosDB"

  # Basic Configuration
  application_name     = each.value.application_name
  environment         = each.value.environment
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  cosmosdb_account_name = each.value.cosmosdb_account_name

  # Account Configuration
  offer_type              = each.value.offer_type
  kind                    = each.value.kind
  enable_automatic_failover = each.value.enable_automatic_failover
  enable_multiple_write_locations = each.value.enable_multiple_write_locations
  public_network_access_enabled = each.value.public_network_access_enabled

  # Consistency Policy
  consistency_policy      = each.value.consistency_policy

  # Capabilities (Serverless mode)
  capabilities            = each.value.capabilities

  # Geo Location
  geo_location           = each.value.geo_location

  # Private Endpoint Configuration
  enable_private_endpoint = lookup(each.value, "enable_private_endpoint", true)
  privatelink_subnet     = lookup(each.value, "privatelink_subnet", null)
  private_dns_zone_ids   = lookup(each.value, "private_dns_zone_ids", [])
  virtual_network_rules  = each.value.virtual_network_rules

  # Backup Configuration
  backup                 = each.value.backup

  # Database and Container Configuration
  sql_databases          = each.value.sql_databases
  sql_containers         = each.value.sql_containers

  # Tagging
  tags = each.value.tags
}# ========================================
# Logic Apps Module
# ========================================
module "logic_apps" {
  for_each = var.logic_apps_services

  source = "../app-service/logic-app"

  # Basic Configuration
  application_name     = each.value.application_name
  environment         = each.value.environment
  resource_group_name = each.value.resource_group_name
  resource_location   = each.value.resource_location

  # Service Plan Configuration
  service_plan_name = each.value.service_plan_name
  service_plan_sku  = each.value.service_plan_sku
  existing_service_plan = each.value.existing_service_plan

  # Identity Configuration
  uai_required = each.value.uai_required
  user_assigned_identity_ids = each.value.user_assigned_identity_ids

  # Storage Configuration
  storage_account_name = each.value.storage_account_name
  sku_name            = each.value.sku_name
  file_shares         = each.value.file_shares
  create_fileshare    = each.value.create_fileshare

  # Security & Keys
  customer_managed_key_enabled = each.value.customer_managed_key_enabled
  kv_name                      = each.value.kv_name
  kv_resource_group_name       = each.value.kv_resource_group_name
  cmk_name                     = each.value.cmk_name
  storage_use                  = each.value.storage_use

  # Private Endpoint Configuration
  privatelink_subnet = each.value.privatelink_subnet
  private_dns_zone_id = each.value.private_dns_zone_id
  file_share_private_dns_zone_id = each.value.file_share_private_dns_zone_id

  # Logic Apps Configuration
  logic_apps               = each.value.logic_apps
  definistion_file_path    = each.value.definistion_file_path

  # Tagging
  tags = each.value.tags
}

# Grant Function App's User-Assigned Managed Identity access to Key Vault
resource "azurerm_role_assignment" "function_app_kv_secrets_user" {
  for_each = {
    for combo in flatten([
      for kv_key, kv_config in var.key_vaults : [
        for fa_key, fa_config in var.function_apps : {
          kv_key = kv_key
          fa_key = fa_key
          kv_id  = module.key_vaults[kv_key].id
          principal_id = module.function_apps[fa_key].user_assigned_identity_principal_id
        }
      ]
    ]) : "${combo.kv_key}-${combo.fa_key}" => combo
  }

  scope                = each.value.kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value.principal_id
  description          = "Grant Function App ${each.value.fa_key} access to Key Vault ${each.value.kv_key}"

  depends_on = [module.key_vaults, module.function_apps]
}

# Grant Function App's User-Assigned Managed Identity access to Container Registry
resource "azurerm_role_assignment" "function_app_acr_pull" {
  for_each = {
    for combo in flatten([
      for acr_key, acr_config in var.container_registries : [
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
