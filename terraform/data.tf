data "azurerm_virtual_network" "connectivity_vnet" {
  provider            = azurerm.connectivity
  name                = var.connectivity_vnet.vnet_name
  resource_group_name = var.connectivity_vnet.resource_group
}

data "azurerm_private_dns_zone" "privatelink_sql" {
  provider            = azurerm.connectivity
  name                = var.privatelink_sql_dns_zone
  resource_group_name = var.connectivity_dns_zone_rg  
}

data "azurerm_private_dns_zone" "aisrch_dns_zone" {
  provider = azurerm.connectivity
  name     = var.aisrch_dns_zone
}

data "azurerm_private_dns_zone" "cosmos_dns_zone" {
  provider = azurerm.connectivity
  name     = var.cosmos_dns_zone
}

data "azurerm_private_dns_zone" "kv_dns_zone" {
  provider = azurerm.connectivity
  name     = var.kv_dns_zone
}

data "azurerm_private_dns_zone" "sa_dns_zone" {
  provider = azurerm.connectivity
  name     = var.sa_dns_zone
}
