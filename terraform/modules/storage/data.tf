data "azurerm_subnet" "privatelink_subnet" {
  count                = var.privatelink_subnet != null ? 1 : 0
  name                 = var.privatelink_subnet.name
  virtual_network_name = var.privatelink_subnet.vnet_name
  resource_group_name  = var.privatelink_subnet.resource_group
}

data "azurerm_key_vault" "keyvault" {
  count               = var.customer_managed_key == true ? 1 : 0
  name                = var.kv_name
  resource_group_name = var.kv_resource_group_name
}