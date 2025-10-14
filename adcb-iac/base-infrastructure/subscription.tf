data "azurerm_management_group" "mgmt_group" {
  count = var.azure_mgmt_group != null ? 1 : 0
  name  = var.azure_mgmt_group
}

resource "azurerm_management_group_subscription_association" "subscription_mgmtgrp_assoc" {
  count = (var.subscription_id != null && var.azure_mgmt_group != null) ? 1 : 0

  management_group_id = data.azurerm_management_group.mgmt_group[0].id
  subscription_id     = var.subscription_id
}