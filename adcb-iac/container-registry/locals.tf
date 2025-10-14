locals {
  location = lower(var.resource_location)
  tags      = var.tags
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode                 = lookup(local.location_shortcode_map, var.resource_location, substr(local.location, 0, 4))
  acr_name                           = format("acr%s%s%s%s", var.application_name, var.environment, local.location_shortcode, module.res-id.result)
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}