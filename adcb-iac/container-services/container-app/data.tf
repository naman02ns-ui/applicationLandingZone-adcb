data "azurerm_container_registry" "acr" {
  count               = var.registry != null ? 1 : 0
  name                = var.registry.name
  resource_group_name = var.registry.resource_group_name
}
