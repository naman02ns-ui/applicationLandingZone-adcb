locals {
  common_tags = { module = "service-plan" }
  rg          = var.resource_group_name
  location    = lower(var.resource_location)
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  tags           = var.tags
  location_shortcode = lookup(local.location_shortcode_map, var.resource_location, substr(local.location, 0, 4))
}