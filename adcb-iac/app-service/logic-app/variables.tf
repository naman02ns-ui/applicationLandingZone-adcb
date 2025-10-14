variable "storage_account_name" {
  type        = string
  default     = null
  description = "The resource group for the redis cache"
}


variable "resource_group_name" {
  type        = string
  description = "The resource group for the redis cache"
}

variable "application_name" {
  type        = string
  description = "The application that requires this resource"
}

variable "environment" {
  type        = string
  description = "Environment where redis cache is provisioned"
  validation {
    condition     = can(regex("^(?:dev|qa|sit|uat|preprod|prod)$", var.environment))
    error_message = "Allowed values for environment: dev,qa,uat,sit,preprod,prod"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to be added to the resources"
  default     = {}
}

variable "service_plan_name" {
  type        = string
  description = "The application that requires this resource"
}

#service plan
variable "service_plan_sku" {
  default     = "WS1"
  description = "The SKU for the App Service Plan (must support Logic App Standard)"
  type        = string
  validation {
    condition     = contains(["WS1", "WS2", "WS3"], var.service_plan_sku)
    error_message = "Valid values for Logic App Standard SKU are: WS1, WS2, and WS3"
  }
}

variable "user_assigned_identity_ids" {
  type        = list(string)
  default     = []
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

##############################Storage account vars
variable "sku_name" {
  type    = string
  default = "Standard_LRS"
}

variable "file_shares" {
  description = "List of file shares to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "customer_managed_key_enabled" {
  type        = bool
  description = "A true or false value as to whether encrypt the storage account with customer managed keys or not"
  default     = false
}

variable "kv_name" {
  description = "The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created"
  type        = string
  default     = null
}

variable "kv_resource_group_name" {
  type        = string
  description = "Resource group name of Azure Container Registry"
  default     = null
}

variable "cmk_name" {
  description = "The customer managed key name to be passed into the keyvault"
  default     = null
}

variable "storage_use" {
  description = "This variables will help to determine which storage account the managed ideneity is for. For example 'func', 'statefile'."
  type        = bool
  default     = false
}

variable "definistion_file_path" {
  type    = string
  default = "path to the Logic App workflow definistion JSON"
}

variable "file_share_private_dns_zone_id" {
  description = "The private dns zone for the Azure File Share"
  default     = null
}

variable "create_fileshare" {
  type        = bool
  description = "Do you require a fileshare to be created?"
  default     = false
}

variable "existing_service_plan" {
  type = object({
    name                = string
    resource_group_name = string
  })
  description = "The details of an existing service plan"
  default     = null
}

variable "resource_location" {
  type        = string
  description = "location of the redis cache"
  default     = "uaenorth"
}

variable "uai_required" {
  type    = bool
  default = true

}

variable "logic_apps" {
  type = map(object({
    name     = string
    env_vars = map(string)
    # file_share_name = string
  }))
}