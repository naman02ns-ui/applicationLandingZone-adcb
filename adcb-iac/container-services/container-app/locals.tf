locals {
  common_tags = { module = "container-app" }
  environment = var.environment
  location    = lower(var.resource_location)
  tags      = var.tags
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode                 = lookup(local.location_shortcode_map, var.resource_location, substr(local.location, 0, 4))
  all_identity_ids                   = concat(local.locally_generated_identity_ids, var.external_identity_ids)
  locally_generated_identity_ids     = [azurerm_user_assigned_identity.acr_pull_id.id, azurerm_user_assigned_identity.kv_identity.id]
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  container_app_name             = substr(format("capp-%s-%s-%s-%s", var.application_name, var.environment, local.location_shortcode, module.res-id.result), 0, 60)

}