locals {
  common_tags = { module = "app-service" }
  tags = var.tags
  rg          = var.resource_group_name
  location    = lower(var.resource_location)
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode              = lookup(local.location_shortcode_map, var.resource_location, substr(local.location, 0, 4))
  logic_app_name                  = substr(format("lapp-%s-%s-%s-%s", var.application_name, var.environment, local.location_shortcode, module.res-id.result), 0, 60)

}