variable "resource_location" {
  type        = string
  description = "Location of Container Registry"
  default     = "uaenorth"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name of Azure Container Registry"
}

variable "zone_redundancy_enabled" {
  type        = string
  description = "zone redundant for acr"
  default     = "false"
}

variable "application_name" {
  type        = string
  description = "The application that requires this resource"
}

variable "environment" {
  type        = string
  description = "Environment to provision resources"
  validation {
    condition     = can(regex("^(?:dev|qa|sit|uat|preprod|prod)$", var.environment))
    error_message = "Allowed values for environment: dev,qa,uat,sit,preprod,prod"
  }
}

variable "key_expiration_date" {
  description = "The expiration date for the Key Vault key in RFC3339 format (e.g., 2026-12-31T23:59:59Z)"
  type        = string
  default     = "2027-12-31T23:59:59Z"
}


variable "sku" {
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium"
  type        = string
  default     = "Premium"
}

variable "azurerm_key_vault_key" {
  description = "Specifies the name of the Key Vault Key. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "kv_name" {
  description = "The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created"
  type        = string
  default     = null
}

variable "admin_enabled" {
  description = "Whether the admin user is enabled."
  type        = bool
  default     = false
}

variable "georeplication_locations" {
  description = <<DESC
  A list of Azure locations where the Ccontainer Registry should be geo-replicated. Only activated on Premium SKU.
  Supported properties are:
    location                  = string
    zone_redundancy_enabled   = bool
    regional_endpoint_enabled = bool
    tags                      = map(string)
  or this can be a list of `string` (each element is a location)
DESC
  type        = any
  default     = []
}

variable "images_retention_enabled" {
  description = "Specifies whether images retention is enabled (Premium only)."
  type        = bool
  default     = false
}

variable "images_retention_days" {
  description = "Specifies the number of images retention days."
  type        = number
  default     = 90
}

variable "retention_policy_in_days" {
  description = "(Optional) The number of days to retain and untagged manifest after which it gets purged. Defaults to 7."
  default     = 7

}

variable "azure_services_bypass_allowed" {
  description = "Whether to allow trusted Azure services to access a network restricted Container Registry."
  type        = bool
  default     = true
}

variable "trust_policy_enabled" {
  description = "Specifies whether the trust policy is enabled (Premium only)."
  type        = bool
  default     = false
}

variable "allowed_cidrs" {
  description = "List of CIDRs to allow on the registry."
  default     = []
  type        = list(string)
}

variable "allowed_subnets" {
  description = "List of VNet/Subnet IDs to allow on the registry."
  default     = []
  type        = list(string)
}

variable "public_network_access_enabled" {
  description = "Whether the Container Registry is accessible publicly."
  type        = bool
  default     = false
}

variable "data_endpoint_enabled" {
  description = "Whether to enable dedicated data endpoints for this Container Registry? (Only supported on resources with the Premium SKU)."
  default     = false
  type        = bool
}

variable "encryption_enabled" {
  description = "Specifies whether encryption is enabled (Premium only)"
  type        = bool
  default     = false
}

variable "privatelink_subnet" {
  type = object({
    name           = string
    vnet_name      = string
    resource_group = string
  })
  description = "Subnet where the private link is required."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "ID of the private dns zone for private link"
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. If you are using a condition, valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
}

variable "tags" {
  type        = map(string)
  description = "User defined extra tags to be added to all resources created in the module"
}