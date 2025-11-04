module "res-id" {
  source = "../../utility/random-identifier"
  # Fixed: Provide stable seed value to prevent recreation
  seed-value = "${var.application_name}-${var.environment}-${var.resource_location}"
}

resource "azurerm_container_app_environment" "container_app_env" {
  location                       = var.resource_location
  name                           = local.container_app_env_name
  resource_group_name            = var.resource_group_name
  #log_analytics_workspace_id     = var.log_analytics_workspace_id
  infrastructure_subnet_id       = var.subnet != null ? data.azurerm_subnet.subnet[0].id : null
  internal_load_balancer_enabled = true
  dynamic "workload_profile" {
    for_each = var.workload_profile != null ? ["workload profile"] : []
    content {
      name                  = var.workload_profile.name
      workload_profile_type = var.workload_profile.workload_profile_type
    }
  }

  tags = local.tags
}