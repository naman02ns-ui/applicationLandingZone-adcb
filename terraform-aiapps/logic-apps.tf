# =============================================================================
# Logic Apps Module
# =============================================================================

module "logic_apps" {
  for_each = var.enable_logic_apps > 0 ? var.logic_apps_services : {}

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

  # Security & Keys - Use existing Key Vault
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