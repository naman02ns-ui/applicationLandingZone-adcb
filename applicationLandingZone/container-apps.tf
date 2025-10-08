# =============================================================================
# Container Apps Module
# =============================================================================

module "container_app_environments" {
  source = "../container-services/container-app-environment"

  for_each = var.enable_container_app_environments > 0 ? var.container_app_environments : {}

  management_sub_id           = each.value.management_sub_id
  resource_location          = each.value.resource_location
  resource_group_name        = each.value.resource_group_name
  application_name           = each.value.application_name
  environment               = each.value.environment
  subnet                    = each.value.subnet
  workload_profile          = each.value.workload_profile
  log_analytics_workspace_id = each.value.log_analytics_workspace_id
  tags                      = each.value.tags
}

module "container_apps" {
  source = "../container-services/container-app"

  for_each = var.enable_container_apps > 0 ? var.container_apps : {}

  resource_location             = each.value.resource_location
  resource_group_name          = each.value.resource_group_name
  application_name             = each.value.application_name
  environment                  = each.value.environment
  tags                        = each.value.tags
  registry                    = each.value.registry
  container_app_environment_id = module.container_app_environments[each.value.container_app_environment_key].container_app_env_id
  ingress_external_enabled     = each.value.ingress_external_enabled
  ingress_target_port         = each.value.ingress_target_port
  ingress_transport           = each.value.ingress_transport
  environment_variables       = each.value.environment_variables
  workload_profile_name       = each.value.workload_profile_name
  container_config            = each.value.container_config
  revision_mode               = each.value.revision_mode
  external_identity_ids       = each.value.external_identity_ids

  depends_on = [module.container_app_environments, module.container_registries]
}