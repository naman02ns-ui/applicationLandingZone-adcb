locals {
  location = lower(var.resource_location)
  tags      = var.tags
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode = lookup(local.location_shortcode_map, var.resource_location, substr(local.location, 0, 4))
  failover_locations = [{
    location          = var.resource_location
    failover_priority = 0
    zone_redundant    = false
  }]
}