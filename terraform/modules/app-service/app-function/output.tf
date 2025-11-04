#output "name" {
#description = "The name of the function app"
#value       = azurerm_linux_function_app.function-app[*].name
#}

output "id" {
  description = "The id of the function app"
  # value       = azurerm_linux_function_app.function-app[*].id
  value = values(azurerm_linux_function_app.function-app)[*].id
}

output "function_app_names" {
  description = "The names of the function apps"
  value = {
    for key, app in azurerm_linux_function_app.function-app : key => app.name
  }
}

output "function_app_principal_ids" {
  description = "The principal IDs of the function apps (system-assigned identities)"
  value = {
    for key, app in azurerm_linux_function_app.function-app : key => app.identity[0].principal_id
  }
}

output "user_assigned_identity_id" {
  description = "The ID of the user-assigned identity"
  value = try(azurerm_user_assigned_identity.uai[0].id, null)
}

output "user_assigned_identity_principal_id" {
  description = "The principal ID of the user-assigned identity"
  value = try(azurerm_user_assigned_identity.uai[0].principal_id, null)
}

output "user_assigned_identity_client_id" {
  description = "The client ID of the user-assigned identity"
  value = try(azurerm_user_assigned_identity.uai[0].client_id, null)
}

output "storage_account_name" {
  description = "The name of the backend storage account used for the function app"
  value = module.storage_account.storage_account_name
}

#output "hostname" {
#description = "The default hostname of the function app"
#value       = azurerm_linux_function_app.function-app[*].default_hostname
#}

#output "backend_storage_account_name" {
#description = "The name of the backend storage account used for the function app"
#value       = module.storage_account.storage_account_name
#}

# output "system_assigned_identity_id" {
#   description = "The id of the system assigned identity"
#   value       = azurerm_linux_function_app.function-app[*].principal_id
# }