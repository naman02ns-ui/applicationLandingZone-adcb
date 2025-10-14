locals {
  location = lower(var.location)
  tags      = var.tags
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode = lookup(local.location_shortcode_map, var.location, substr(local.location, 0, 4))
  environment        = lower(var.environment)
}