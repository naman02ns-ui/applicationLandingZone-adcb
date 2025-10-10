# =============================================================================
# Key Vault Module
# =============================================================================

module "key_vaults" {
  for_each = var.enable_key_vaults > 0 ? var.key_vaults : {}

  source = "../kv"

  # Basic Configuration
  application_name              = each.value.application_name
  environment                   = each.value.environment
  resource_group_name           = each.value.resource_group_name
  resource_location             = each.value.resource_location

  # Key Vault Configuration
  enabled_for_deployment        = each.value.enabled_for_deployment
  enabled_for_disk_encryption   = each.value.enabled_for_disk_encryption
  purge_protection_enabled      = each.value.purge_protection_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  rbac_authorization_enabled    = each.value.rbac_authorization_enabled
  sku_name                      = each.value.sku_name
  soft_delete_retention_days    = each.value.soft_delete_retention_days

  # Network Access Control
  network_acls = each.value.network_acls

  # RBAC Assignments
  role_assignments = each.value.role_assignments

  # Private Endpoint Configuration
  privatelink_subnet = each.value.privatelink_subnet
  private_dns_zone_name = each.value.private_dns_zone_name
  private_dns_zone_id   = each.value.private_dns_zone_id

  # Management
  lock   = each.value.lock

  # Monitoring
  diagnostic_settings = each.value.diagnostic_settings

  # Tagging
  tags = each.value.tags
}