# Outputs for Application Landing Zone

# Key Vault Outputs
output "key_vaults" {
  description = "Key Vault configurations and details"
  value = {
    for k, v in module.key_vaults : k => {
      id   = v.id
      name = v.name
      uri  = v.vault_uri
    }
  }
}

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

# AI Search Service Outputs
output "ai_search_services" {
  description = "AI Search service configurations and details"
  value = {
    for k, v in module.ai_search_services : k => {
      id                    = v.id
      name                  = v.name
      search_service_url    = v.search_service_url
      query_keys           = v.query_keys
      primary_key          = v.primary_key
      secondary_key        = v.secondary_key
      private_endpoint_id  = v.private_endpoint_id
      private_endpoint_ip  = v.private_endpoint_ip_address
    }
  }
  sensitive = true
}

# Cosmos DB Service Outputs
output "cosmos_db_services" {
  description = "Cosmos DB service configurations and details"
  value = {
    for k, v in module.cosmos_db : k => {
      id                    = v.cosmosdb_account_id
      name                  = v.cosmosdb_account_name
      endpoint              = v.cosmosdb_account_endpoint
      primary_key           = v.cosmosdb_account_primary_key
      secondary_key         = v.cosmosdb_account_secondary_key
      # connection_strings    = v.cosmosdb_account_connection_strings
      databases             = v.cosmosdb_databases
      containers            = v.cosmosdb_containers
      private_endpoint_id   = v.private_endpoint_id
      private_endpoint_ip   = v.private_endpoint_ip_address
    }
  }
  sensitive = true
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