module "storage" {
  source                        = "../azure-terraform/modules/storage"
  storage_account_name          = "sa-${var.application_name}-${var.environment}"
  resource_group                = module.resource_group.rg_name
  application_name              = var.application_name
  managed_identity_type         = "UserAssigned"
  public_network_access_enabled = false
  tags                          = local.tags
  kv_name                       = module.azure_key_vault.name
  kv_resource_group_name        = module.resource_group.rg_name
  privatelink_subnet = {
    name           = module.base-infra.subnet_map[var.selected_subnet].name
    vnet_name      = module.base-infra.vnet_name
    resource_group = module.resource_group.rg_name
  }

  azurerm_key_vault_key = "sa-enc-key"
  private_dns_zone_ids  = data.azurerm_private_dns_zone.sa_dns_zone.id
  containers_list = [
    {
      name        = "${var.application_name }-${var.environment}-${var.containername}"
      access_type = "private"
    },

  ]
  storage_use = "doc-intel"
}
