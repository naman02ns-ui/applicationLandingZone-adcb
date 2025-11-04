data "azurerm_subnet" "subnet" {
  count                = var.subnet != null ? 1 : 0
  name                 = var.subnet.name
  resource_group_name  = var.subnet.resource_group
  virtual_network_name = var.subnet.vnet_name
}