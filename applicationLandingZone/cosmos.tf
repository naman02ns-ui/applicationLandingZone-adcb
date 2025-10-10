# =============================================================================
# Cosmos DB Module
# =============================================================================

module "cosmos_db" {
  for_each = var.enable_cosmos_db > 0 ? var.cosmos_accounts : {}

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
  consistency_policy = each.value.consistency_policy

  # Capabilities
  capabilities = each.value.capabilities

  # Geo Location
  geo_location = each.value.geo_location

  # Private Endpoint Configuration
  enable_private_endpoint = each.value.enable_private_endpoint
  privatelink_subnet = each.value.privatelink_subnet
  private_dns_zone_ids   = each.value.private_dns_zone_ids
  virtual_network_rules  = []

  # Backup Configuration
  backup = each.value.backup

  # Database and Container Configuration
  sql_databases = each.value.sql_databases
  sql_containers = each.value.sql_containers

  # Tagging
  tags = each.value.tags
}