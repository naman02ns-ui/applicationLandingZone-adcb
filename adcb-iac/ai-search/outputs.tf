output "search_service_id" {
  description = "The ID of the Search Service."
  value       = azurerm_search_service.search_service.id
}

output "search_service_name" {
  description = "The name of the Search Service."
  value       = azurerm_search_service.search_service.name
}

output "search_service_primary_key" {
  description = "The Primary Key used for Search Service Administration."
  value       = azurerm_search_service.search_service.primary_key
}

output "search_service_secondary_key" {
  description = "The Secondary Key used for Search Service Administration."
  value       = azurerm_search_service.search_service.secondary_key
}

output "search_service_query_keys" {
  description = "Query keys"
  value       = azurerm_search_service.search_service.query_keys
}

output "search_service_query_keys_map" {
  description = "Query keys, returned as a map with array of values."
  value       = { for e in azurerm_search_service.search_service.query_keys : e.name => e.key... }
}

# output "search_service_url" {
#   description = "URL of the Search Service."
#   value       = "https://${local.search_name}.search.windows.net"
# }

output "search_service_identity_principal_id" {
  description = "Service principal ID for the Search Service identity"
  value       = azurerm_search_service.search_service.identity[0].principal_id
}