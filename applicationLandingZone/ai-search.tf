# =============================================================================
# AI Search Module
# =============================================================================

module "ai_search_services" {
  for_each = var.enable_ai_search_services > 0 ? var.ai_search_services : {}

  source = "../AI-Search"

  # Basic Configuration
  resource_group_name    = each.value.resource_group_name
  location              = each.value.location
  application_name      = each.value.application_name
  environment           = each.value.environment
  location_shortcode    = each.value.location_shortcode

  # Service Configuration
  sku                   = each.value.sku
  partition_count       = each.value.partition_count
  replica_count         = each.value.replica_count
  hosting_mode          = each.value.hosting_mode

  # Security Configuration
  public_network_access_enabled = each.value.public_network_access_enabled
  allowed_ips           = each.value.allowed_ips
  authentication_failure_mode = each.value.authentication_failure_mode
  customer_managed_key_enforcement_enabled = each.value.customer_managed_key_enforcement_enabled
  enable_system_assigned_identity = each.value.enable_system_assigned_identity

  # Private Endpoint Configuration
  private_endpoint_enabled = each.value.private_endpoint_enabled
  private_endpoint_subnet_name = each.value.private_endpoint_subnet_name
  virtual_network_name = each.value.virtual_network_name
  network_resource_group_name = each.value.network_resource_group_name
  private_dns_zone_id = each.value.private_dns_zone_id

  # Monitoring Configuration
  log_analytics_workspace_id = each.value.log_analytics_workspace_id
  diagnostic_logs_retention_days = each.value.diagnostic_logs_retention_days
  diagnostic_metrics_retention_days = each.value.diagnostic_metrics_retention_days

  # RBAC Configuration
  contributor_principal_ids = each.value.contributor_principal_ids
  index_data_contributor_principal_ids = each.value.index_data_contributor_principal_ids
  index_data_reader_principal_ids = each.value.index_data_reader_principal_ids

  # Management
  cost_center = each.value.cost_center
  owner = each.value.owner
  project = each.value.project

  # Tagging
  tags = each.value.tags
}