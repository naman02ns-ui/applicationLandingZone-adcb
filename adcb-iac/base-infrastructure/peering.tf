resource "azurerm_virtual_network_peering" "peer-vnet-to-Hub" {

  count = var.connectivity_vnet_id != null ? 1 : 0

  name                         = "peer-${var.app_name}-to-Hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.vnet_name
  remote_virtual_network_id    = var.connectivity_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}