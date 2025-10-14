module "res-id" {
  source = "../utility/random-identifier"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = local.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_spaces
  dns_servers         = var.dns_servers
  tags                         = local.tags

  lifecycle {
    ignore_changes = [ddos_protection_plan]
  }
}

resource "azurerm_network_watcher" "nwatcher" {
  count               = var.create_network_watcher != false ? 1 : 0
  name                = "${var.vnet_name}-nw"
  location            = local.location
  resource_group_name = var.resource_group_name
  tags                = merge({ "Name" = format("%s", "NetworkWatcher_${local.location}") }, local.tags, )
}

resource "azurerm_subnet" "snet" {
  for_each                                      = var.subnets
  name                                          = each.value.subnet_name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = each.value.subnet_address_prefix
  service_endpoints                             = lookup(each.value, "service_endpoints", [])
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies", null)


  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != null ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }
}

