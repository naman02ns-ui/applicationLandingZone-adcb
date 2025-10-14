output "acr_name" {
  description = "Azure Container Registry Name"
  value       = azurerm_container_registry.acr.name
}

output "acr_id" {
  description = "Azure Container Registry ID"
  value       = azurerm_container_registry.acr.id
}

output "acr_rg" {
  description = "Azure Container Registry Resource Group"
  value       = azurerm_container_registry.acr.resource_group_name
}

output "acr_assigned_identity" {
  description = "Name of the assigned identity to acr"
  value       = var.encryption_enabled ? azurerm_user_assigned_identity.acr_managed_identity[0].name : null
}