output "name" {
description = "The name of the logic app"
# value       = azurerm_logic_app_standard.this[*].name
value        = [for la in values(azurerm_logic_app_standard.this) : la.name]
}

/*
output "id" {
  description = "The id of the logic app"
  value = values(azurerm_logic_app_standard.this)[*].id
} */

#output "hostname" {
#description = "The default hostname of the function app"
#value       = azurerm_linux_function_app.function-app[*].default_hostname
#}

output "backend_storage_account_name" {
description = "The name of the backend storage account used for the function app"
value       = module.storage_account.storage_account_name
}

# Output for User-Assigned Managed Identity
output "user_assigned_identity_id" {
  description = "The ID of the User-Assigned Managed Identity"
  value       = var.uai_required ? azurerm_user_assigned_identity.uai[0].id : null
}

output "user_assigned_identity_principal_id" {
  description = "The Principal ID of the User-Assigned Managed Identity"
  value       = var.uai_required ? azurerm_user_assigned_identity.uai[0].principal_id : null
}

/*
output "backend_storage_account_access_key" {
description = "The name of the backend storage account used for the function app"
value       = module.storage_account.primary_access_key
}

output "backend_storage_account_id" {
description = "The name of the backend storage account used for the function app"
value       = values(module.storage_account)[*].id
} */