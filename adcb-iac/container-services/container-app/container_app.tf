module "res-id" {
  source = "../../utility/random-identifier"
}
resource "azurerm_user_assigned_identity" "acr_pull_id" {
  location            = var.resource_location
  name                = "${var.application_name}-acrPullId-uai"
  resource_group_name = var.resource_group_name
  tags                         = local.tags
}

resource "azurerm_role_assignment" "acr_role_assignment" {
  scope                = data.azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_pull_id.principal_id
  lifecycle {
    ignore_changes = [scope]
  }
}

resource "azurerm_user_assigned_identity" "kv_identity" {
  location            = var.resource_location
  name                = "${var.application_name}-kvIdentity"
  resource_group_name = var.resource_group_name
  tags                         = local.tags
}

/*
resource "azurerm_role_assignment" "kv_role_assignment" {
  scope                = data.azurerm_key_vault.kv[0].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.kv_identity.principal_id
  lifecycle {
    ignore_changes = [scope]
  }
}
*/

resource "azurerm_container_app" "container_app" {
  name                         = local.container_app_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  workload_profile_name        = var.workload_profile_name
  revision_mode                = var.revision_mode
   template {
    container {
      name   = var.container_config.name
      image  = var.container_config.image
      cpu    = var.container_config.cpu
      memory = var.container_config.memory
    }
  }

  ingress {
    external_enabled = var.ingress_external_enabled
    target_port      = var.ingress_target_port
    transport        = var.ingress_transport
    traffic_weight {
      percentage = 100
      latest_revision = true
    }
  }
   registry {
    server = "${var.registry.name}.azurecr.io"
    identity = azurerm_user_assigned_identity.acr_pull_id.id
  }


  identity {
    type         = "UserAssigned"
    identity_ids = local.all_identity_ids
  }
  tags                         = local.tags
}
