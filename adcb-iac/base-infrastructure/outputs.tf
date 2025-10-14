output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Name of the Virtual Network"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Name of the Virtual Network"
}


output "subnet_names" {
  value = values(azurerm_subnet.snet)[*].name
}

# output "subnet_names" {
#   value = azurerm_subnet.snet[*]
# }

output "subnet_map" {
  value = {
    for snet in azurerm_subnet.snet : snet.name =>
    {
      name           = snet.name
      id             = snet.id
      vnet_name      = azurerm_virtual_network.vnet.name
      vnet_id        = azurerm_virtual_network.vnet.id
      resource_group = var.resource_group_name
    }
  }
}