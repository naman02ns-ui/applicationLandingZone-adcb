# Outputs for Cosmos DB Module

output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.id
}

output "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.name
}

output "cosmosdb_account_endpoint" {
  description = "The endpoint of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "cosmosdb_account_primary_key" {
  description = "The primary key of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "cosmosdb_account_secondary_key" {
  description = "The secondary key of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.secondary_key
  sensitive   = true
}

output "cosmosdb_account_primary_readonly_key" {
  description = "The primary readonly key of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.primary_readonly_key
  sensitive   = true
}

output "cosmosdb_account_secondary_readonly_key" {
  description = "The secondary readonly key of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.secondary_readonly_key
  sensitive   = true
}

# output "cosmosdb_account_connection_strings" {
#   description = "A list of connection strings available for this CosmosDB account."
#   value       = azurerm_cosmosdb_account.this.connection_strings
#   sensitive   = true
# }

output "cosmosdb_databases" {
  description = "The list of created databases."
  value = {
    for db in azurerm_cosmosdb_sql_database.database : db.name => {
      id   = db.id
      name = db.name
    }
  }
}

output "cosmosdb_containers" {
  description = "The list of created containers."
  value = {
    for container in azurerm_cosmosdb_sql_container.container : container.name => {
      id                = container.id
      name              = container.name
      database_name     = container.database_name
      partition_key_paths = container.partition_key_paths
    }
  }
}

output "private_endpoint_id" {
  description = "The ID of the private endpoint."
  value       = var.enable_private_endpoint && var.privatelink_subnet != null ? azurerm_private_endpoint.cosmosdb_pe[0].id : null
}

output "private_endpoint_ip_address" {
  description = "The private IP address of the private endpoint."
  value       = var.enable_private_endpoint && var.privatelink_subnet != null ? azurerm_private_endpoint.cosmosdb_pe[0].private_service_connection[0].private_ip_address : null
}
