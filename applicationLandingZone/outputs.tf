# Outputs for Application Landing Zone

# =============================================================================
# Existing Resources Outputs (Customer Provided)
# =============================================================================

# Existing Key Vault Outputs
output "existing_key_vaults" {
  description = "Existing Key Vault details"
  value = var.enable_existing_key_vaults > 0 ? {
    for k, v in data.azurerm_key_vault.existing : k => {
      id   = v.id
      name = v.name
      uri  = v.vault_uri
    }
  } : {}
}

# Existing Storage Account Outputs
output "existing_storage_accounts" {
  description = "Existing Storage Account details"
  value = var.enable_existing_storage_accounts > 0 ? {
    for k, v in data.azurerm_storage_account.existing : k => {
      id   = v.id
      name = v.name
    }
  } : {}
}

# Existing AI Search Service Outputs
output "existing_ai_search_services" {
  description = "Existing AI Search Service details"
  value = var.enable_existing_ai_search_services > 0 ? {
    for k, v in data.azurerm_search_service.existing : k => {
      id   = v.id
      name = v.name
    }
  } : {}
}

# Existing Log Analytics Workspace Outputs
output "existing_log_analytics_workspaces" {
  description = "Existing Log Analytics Workspace details"
  value = var.enable_existing_log_analytics_workspaces > 0 ? {
    for k, v in data.azurerm_log_analytics_workspace.existing : k => {
      id   = v.id
      name = v.name
      workspace_id = v.workspace_id
    }
  } : {}
}

# Existing Cosmos DB Account Outputs
output "existing_cosmos_db_accounts" {
  description = "Existing Cosmos DB Account details"
  value = var.enable_existing_cosmos_db > 0 ? {
    for k, v in data.azurerm_cosmosdb_account.existing : k => {
      id   = v.id
      name = v.name
      endpoint = v.endpoint
    }
  } : {}
}

# =============================================================================
# New Resources Outputs (Deployed by Terraform)
# =============================================================================

# Function App Outputs
output "function_apps" {
  description = "Function App configurations and details"
  value = {
    for k, v in module.function_apps : k => {
      id = v.id
    }
  }
}

# Container Registry Outputs
output "container_registries" {
  description = "Container Registry configurations and details"
  value = {
    for k, v in module.container_registries : k => {
      acr_id = v.acr_id
      acr_name = v.acr_name
    }
  }
}

# Container App Environment Outputs
output "container_app_environments" {
  description = "Container App Environment configurations and details"
  value = {
    for k, v in module.container_app_environments : k => {
      id = v.container_app_env_id
    }
  }
}

# Container App Outputs
output "container_apps" {
  description = "Container App configurations and details"
  value = {
    for k, v in module.container_apps : k => {
      id = v.id
    }
  }
}

# Logic Apps Service Outputs
output "logic_apps_services" {
  description = "Logic Apps service configurations and details"
  value = {
    for k, v in module.logic_apps : k => {
      logic_app_names         = v.name
      storage_account_name    = v.backend_storage_account_name
    }
  }
}