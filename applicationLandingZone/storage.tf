# =============================================================================
# Storage Account Module
# =============================================================================

module "storage_accounts" {
  for_each = var.enable_storage_accounts > 0 ? var.storage_accounts : {}

  source = "../storage"

  # Basic Configuration
  environment         = var.environment
  resource_group      = each.value.resource_group_name
  location            = each.value.location
  application_name    = each.value.application_name
  storage_account_name = each.value.storage_account_name

  # Storage Account Configuration
  account_kind                        = each.value.account_kind
  skuname                            = each.value.skuname
  min_tls_version                    = each.value.min_tls_version
  public_network_access_enabled      = each.value.public_network_access_enabled
  allow_nested_items_to_be_public    = each.value.allow_nested_items_to_be_public
  cross_tenant_replication_enabled   = each.value.cross_tenant_replication_enabled

  # Security Configuration
  infrastructure_encryption_enabled  = each.value.infrastructure_encryption_enabled
  customer_managed_key               = each.value.customer_managed_key
  azurerm_key_vault_key             = each.value.azurerm_key_vault_key
  kv_name                           = each.value.kv_name
  kv_resource_group_name            = each.value.kv_resource_group_name
  key_expiration_date               = each.value.key_expiration_date

  # Managed Identity Configuration
  managed_identity_type = each.value.managed_identity_type
  managed_identity_ids  = each.value.managed_identity_ids

  # Storage Use Configuration
  storage_use = "general"

  # Additional Storage Configuration
  containers_list = []
  file_shares     = []
  queues         = []
  tables         = []
  network_rules  = null

  # Blob Configuration
  blob_soft_delete_retention_days      = each.value.blob_soft_delete_retention_days
  container_soft_delete_retention_days = each.value.container_soft_delete_retention_days
  enable_versioning                    = each.value.enable_versioning
  last_access_time_enabled            = each.value.last_access_time_enabled

  # Lifecycle Management
  lifecycles = each.value.management_policy_rules

  # Private Endpoint Configuration
  privatelink_subnet      = each.value.privatelink_subnet
  private_dns_zone_ids    = each.value.private_dns_zone_ids

  # Tags
  tags = each.value.tags
}