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
  registry = {
    name                = module.container_registries["app-dev-acr"].acr_name
    resource_group_name = each.value.resource_group_name
  }
  container_app_environment_id = module.container_app_environments[each.value.container_app_environment_name].container_app_env_id
  ingress_external_enabled     = try(each.value.ingress.external_enabled, false)
  ingress_target_port         = try(each.value.ingress.target_port, 80)
  ingress_transport           = "auto"
  environment_variables       = {}
  workload_profile_name       = "Consumption"
  container_config = {
    name   = try(each.value.containers[0].name, "default")
    cpu    = try(each.value.containers[0].cpu, "0.25")
    memory = try(each.value.containers[0].memory, "0.5Gi")
    image  = try(each.value.containers[0].image, "nginx:latest")
  }
  revision_mode               = each.value.revision_mode
  external_identity_ids       = try(each.value.identity.identity_ids, [])

  depends_on = [module.container_app_environments, module.container_registries]
}