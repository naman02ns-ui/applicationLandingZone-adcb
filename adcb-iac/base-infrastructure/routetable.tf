resource "azurerm_route_table" "udr" {
  for_each                      = { for k, v in var.subnets : k => v if k != "bastion-subnet" }
  name                          = lower("rt-${each.key}")
  location                      = local.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = false
  tags                          = merge({ "Name" = format("%s", "rt_${each.key}") }, local.tags, )

  dynamic "route" {
    for_each = lookup(each.value, "route_table_rules", [])
    content {
      name                   = route.value[0]
      address_prefix         = route.value[1]
      next_hop_type          = route.value[2]
      next_hop_in_ip_address = route.value[3]
    }
  }

  depends_on = [
    azurerm_subnet.snet
  ]
}

resource "azurerm_subnet_route_table_association" "rt-assoc" {
  for_each       = { for k, v in var.subnets : k => v if k != "bastion-subnet" }
  subnet_id      = azurerm_subnet.snet[each.key].id
  route_table_id = azurerm_route_table.udr[each.key].id
}