resource "azurerm_user_assigned_identity" "uai" {
  count               = var.uai_required ? 1 : 0
  location            = local.location
  name                = format("rsv-id-%s-%s-%s-%s", var.application_name, var.environment, lookup(local.location_shortcode_map, local.location, substr(var.resource_location, 0, 4)), module.res-id.result)
  resource_group_name = local.rg
  tags                = var.tags
}