# =============================================================================
# Container Registry Module
# =============================================================================

module "container_registries" {
  source = "../adcb-iac/container-registry"

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
  tags                          = local.tags
}