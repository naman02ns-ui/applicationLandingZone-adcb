variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = ""
}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}

variable "owners" {
  description = "Project owners email address/AAD Group name"
  type        = string
  default     = ""
}


variable "resource_group" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}
variable "key_expiration_date" {
  description = "The expiration date for the Key Vault key in RFC3339 format (e.g., 2026-12-31T23:59:59Z)"
  type        = string
  default     = "2027-12-31T23:59:59Z"
}

variable "private_dns_zone_ids" {
  default = null
}
variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "uaenorth"
  type        = string
}

variable "application_name" {
  type        = string
  description = "The application that requires this resource"
  default     = ""
}

variable "storage_account_name" {
  description = "The name of the azure storage account"
  default     = ""
  type        = string
}

variable "storage_account_id" {
  description = "The name of the azure storage account"
  default     = ""
  type        = string
}

variable "account_kind" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  default     = "StorageV2"
  type        = string
}

variable "skuname" {
  description = "The SKUs supported by Microsoft Azure Storage. Valid options are Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS"
  default     = "Standard_RAGRS"
  type        = string
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
  type        = string
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "enable_versioning" {
  description = "Is versioning enabled? Default to `false`"
  default     = true
  type        = bool
}

variable "last_access_time_enabled" {
  description = "Is the last access time based tracking enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled?"
  default     = false
  type        = bool
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
  type        = bool
}

variable "network_rules" {
  description = "Network rules restricting access to the storage account."
  type        = object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  default     = null
}

variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "file_shares" {
  description = "List of file shares to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "storage_use" {
  description = "This variables will help to determine which storage account the managed ideneity is for. For example 'func', 'statefile'."
  type        = string
}

variable "queues" {
  description = "List of storages queues"
  type        = list(string)
  default     = []
}

variable "tables" {
  description = "List of storage tables."
  type        = list(string)
  default     = []
}

variable "lifecycles" {
  description = "Configure Azure Storage firewalls and virtual networks"
  type = list(
    object({
      prefix_match               = set(string),
      tier_to_cool_after_days    = number,
      tier_to_archive_after_days = number,
      delete_after_days          = number,
      snapshot_delete_after_days = number
  }))
  default = []
}

variable "infrastructure_encryption_enabled" {
  description = "Enable infrastructure encryption for storage account"
  type        = bool
  default     = true
}

variable "customer_managed_key" {
  description = "Enable customer managed key for enrcyption for storage accounts"
  type        = bool
  default     = true
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

variable "kv_resource_group_name" {
  type        = string
  description = "The RG of thhe KV"
  default     = null
}


# variable "managed_hsm_key_id" {
#   description = "Enable managed HSM key for enrcyption for storage accounts"
#   type        = string
#   default     = ""
# }
# variable "kv_name" {
#   description = "The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created"
#   type        = string
#   default     = null
# }
# variable "kv_resource_group_name" {
#   type        = string
#   description = "Resource group name of storage account"
#   default     = null
# }

variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned to the Storage account. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  default     = null
  type        = string
}

variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine."
  default     = null
  type        = list(string)
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

variable "tags" {
  type        = map(string)
  description = "User defined extra tags to be added to all resources created in the module"
}

variable "public_network_access_enabled" {
  description = "Determines whether public access is enabled - this should be false"
  default     = true

}

variable "allow_nested_items_to_be_public" {
  description = "Determines whether public access is enabled - this should be false"
  default     = false

}

variable "cross_tenant_replication_enabled" {
  type    = bool
  default = true
}