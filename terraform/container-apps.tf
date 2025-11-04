# =============================================================================
# Container Apps Module
# =============================================================================

module "container_app_environments" {
  source = "./modules/container-services/container-app-environment"

  for_each = var.container_app_environments

  management_sub_id           = each.value.management_sub_id
  resource_location          = each.value.resource_location
  resource_group_name        = each.value.resource_group_name
  application_name           = each.value.application_name
  environment               = each.value.environment
  subnet                    = each.value.subnet
  workload_profile          = each.value.workload_profile
  log_analytics_workspace_id = each.value.log_analytics_workspace_id
  tags                      = local.tags

  depends_on = [module.base-infra]
}

module "container_apps" {
  source = "../adcb-iac/container-services/container-app"

  for_each = var.container_apps

  resource_location             = each.value.resource_location
  resource_group_name          = each.value.resource_group_name
  application_name             = each.value.application_name
  environment                  = each.value.environment
  tags                        = local.tags
  registry = {
    name                = length(var.container_registries) > 0 ? values(module.container_registries)[0].acr_name : ""
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

# =============================================================================
# RBAC Assignments for Container Apps
# =============================================================================

# Grant Container Apps access to pull images from Container Registry
resource "azurerm_role_assignment" "container_app_acr_pull" {
  for_each = {
    for combo in flatten([
      for acr_key, acr_config in var.container_registries : [
        for ca_key, ca_config in var.container_apps : {
          acr_key = acr_key
          ca_key  = ca_key
          acr_id  = module.container_registries[acr_key].acr_id
          principal_id = try(ca_config.identity.identity_ids[0], null)
        } if try(ca_config.identity.identity_ids[0], null) != null
      ]
    ]) : "${combo.acr_key}-${combo.ca_key}" => combo
  }

  scope                = each.value.acr_id
  role_definition_name = "AcrPull"
  principal_id         = each.value.principal_id

  depends_on = [module.container_registries, module.container_apps]
}

# Grant Container Apps access to Key Vault secrets
resource "azurerm_role_assignment" "container_app_kv_secrets_user" {
  for_each = {
    for ca_key, ca_config in var.container_apps : ca_key => {
      principal_id = try(ca_config.identity.identity_ids[0], null)
    } if try(ca_config.identity.identity_ids[0], null) != null
  }

  scope                = module.azure_key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value.principal_id
  description          = "Grant Container App ${each.key} access to Key Vault"

  depends_on = [module.azure_key_vault, module.container_apps]
}