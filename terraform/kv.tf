
module "azure_key_vault" {
  source                      = "../azure-terraform/modules/key-vault"
  resource_group_name         = module.resource_group.rg_name
  environment                 = var.environment
  application_name            = var.application_name
  enabled_for_disk_encryption = true
  rbac_authorization_enabled  = true
  network_acls = {
    bypass = "AzureServices"
  }
  privatelink_subnet = {
    name           = module.base-infra.subnet_map[var.selected_subnet].name
    vnet_name      = module.base-infra.vnet_name
    resource_group = module.resource_group.rg_name
  }
  private_dns_zone_id = data.azurerm_private_dns_zone.kv_dns_zone.id
  tags                = local.tags
} 

/*
#creates a vnl between the kv private dns zone and ai subs
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault-vnl" {
  provider              = azurerm.connectivity
  name                  = "${var.application_name}-${var.environment}-vnl"
  resource_group_name   = "rg-connectivity-dns-uaenorth-01"
  private_dns_zone_name = data.azurerm_private_dns_zone.kv_dns_zone.name
  virtual_network_id    = module.base-infra.vnet_id
} 
*/
