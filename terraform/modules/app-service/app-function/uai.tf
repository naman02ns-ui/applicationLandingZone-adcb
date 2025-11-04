resource "azurerm_user_assigned_identity" "uai" {
  count               = var.uai_required ? 1 : 0
  location            = local.location
  name                = var.uai_name_override != null ? var.uai_name_override : format("uai-%s-%s-func-%s", var.application_name, var.environment, lookup(local.location_shortcode_map, local.location, substr(var.resource_location, 0, 4)))
  resource_group_name = local.rg
  tags                = var.tags
}