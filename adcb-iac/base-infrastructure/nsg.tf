resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnets
  name                = lower("nsg-${each.key}")
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags

  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_inbound_rules", []), lookup(each.value, "nsg_outbound_rules", []))
    content {
      name                   = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                    = tonumber(security_rule.value[1])
      direction              = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                 = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol               = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range = (
        length(split(",", security_rule.value[5])) == 1
        ? trim(split(",", security_rule.value[5])[0], " ")
        : null
      )

      source_port_ranges = (
        length(split(",", security_rule.value[5])) > 1
        ? [for p in split(",", security_rule.value[5]) : trim(p, " ")]
        : null
      )

      destination_port_range = (
        length(split(",", security_rule.value[6])) == 1
        ? trim(split(",", security_rule.value[6])[0], " ")
        : null
      )

      destination_port_ranges = (
         length(split(",", security_rule.value[6])) > 1
         ? [for p in split(",", security_rule.value[6]) : trim(p, " ")]
         : null
      )


      source_address_prefix = (
        length(split(",", security_rule.value[7])) == 1
        ? trim(split(",", security_rule.value[7])[0], " ")
        : null
      )

      source_address_prefixes = (
        length(split(",", security_rule.value[7])) > 1
        ? [for p in split(",", security_rule.value[7]) : trim(p, " ")]
        : null
      )

      destination_address_prefix = (
        length(split(",", security_rule.value[8])) == 1
        ? trim(split(",", security_rule.value[8])[0], " ")
        : null
      )

      destination_address_prefixes = (
        length(split(",", security_rule.value[8])) > 1
        ? [for p in split(",", security_rule.value[8]) : trim(p, " ")]
        : null
      )

      description                  = length(security_rule.value) > 9 ? (length(security_rule.value[9]) > 0 ? substr(security_rule.value[9], 0, 140) : substr("${security_rule.value[2]}_Port_${security_rule.value[6]}", 0, 140)) : substr("${security_rule.value[2]}_Port_${security_rule.value[6]}", 0, 140)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}