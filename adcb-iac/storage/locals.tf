locals {
  owners      = var.owners
  project     = var.business_divsion
  environment = var.environment
  location    = lower(var.location)
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode = lookup(local.location_shortcode_map, var.location, substr(var.location, 0, 4))
  common_tags = {
    owners      = local.owners
    project     = local.project
    environment = local.environment
  }
  tags  = var.tags
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.skuname)[1])
}