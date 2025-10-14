output "container_app_env_id" {
  description = "The id of the container app environment"
  value       = azurerm_container_app_environment.container_app_env.id
}

output "container_app_env_name" {
  description = "The name of the container app environment"
  value       = azurerm_container_app_environment.container_app_env.name
}