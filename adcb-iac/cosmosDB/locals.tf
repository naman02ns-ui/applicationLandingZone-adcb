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
    CreatedBy   = "Terraform"
    Application = var.application_name
    Environment = var.environment
    Purpose     = "Knowledge Management Data"
    ResourceType = "Cosmos DB"
  }
}