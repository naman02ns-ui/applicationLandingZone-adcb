locals {
  environment = var.environment
  location    = lower(var.resource_location)
  tags      = var.tags
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode                 = lookup(local.location_shortcode_map, var.resource_location, substr(local.location, 0, 4))
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  cognitive_account_name             = substr(format("doc-%s-%s-%s-%s", var.application_name, var.environment, local.location_shortcode, module.cognitive_account_name.result), 0, 24)
}

module "cognitive_account_name" {
  source = "../utility/random-identifier"
}