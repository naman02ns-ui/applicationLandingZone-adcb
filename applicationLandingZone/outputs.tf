# Outputs for Application Landing Zone

# =============================================================================
# ADCB Module Outputs (Deployed by Terraform)
# =============================================================================

# Key Vault Outputs
output "key_vault" {
  description = "Key Vault details from ADCB module"
  value = {
    id   = module.key_vaults.key_vault_id
    name = module.key_vaults.key_vault_name
    uri  = module.key_vaults.key_vault_uri
  }
}

# AI Search Service Outputs
output "ai_search_service" {
  description = "AI Search Service details from ADCB module"
  value = {
    id   = module.ai_search_services.search_service_id
    name = module.ai_search_services.search_service_name
  }
}

# Cosmos DB Account Outputs
output "cosmos_db_account" {
  description = "Cosmos DB Account details from ADCB module"
  value = {
    id       = module.cosmos_db.cosmosdb_account_id
    name     = module.cosmos_db.cosmosdb_account_name
    endpoint = module.cosmos_db.cosmosdb_account_endpoint
  }
}

# Storage Account Outputs
output "storage_account" {
  description = "Storage Account details from ADCB module"
  value = {
    id   = module.storage_accounts.storage_account_id
    name = module.storage_accounts.storage_account_name
  }
}

# =============================================================================
# Legacy Application Services Outputs (if needed)
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