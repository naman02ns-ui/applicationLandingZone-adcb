variable "resource_location" {
  type        = string
  description = "location of the redis cache"
  default     = "uaenorth"
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

}

#service plan
variable "service_plan_sku" {
  default     = "Y1"
  description = "The SKU for the service plan"
  type        = string
  validation {
    condition     = contains(["EP1", "EP2", "EP3", "Y1"], var.service_plan_sku)
    error_message = "Valid values for service plan sku are: (Y1, EP1, EP2, and EP3)"
  }
}

variable "max_elastic_worker_count" {
  type        = number
  description = "The maximum elastic workers present in a elastic service plan"
  default     = null
}

variable "public_network_access_enable" {
  type        = bool
  description = "Should public access be enabled for storage accounts"
  default     = true
}


#function app
variable "app_function_subnet" {
  type = object({
    name           = string
    vnet_name      = string
    resource_group = string
  })
  description = "The subnet id which will be used by this function app for regional virtual network integration."
  default     = null
}

variable "uai_required" {
  type    = bool
  default = true

}
variable "sku_name" {
  type    = string
  default = "Standard_LRS"
}

variable "function_apps" {
  type = map(object({
    name     = string
    env_vars = map(string)
    file_share_name = string
  }))
}

variable "application_insights_connection_string" {
  description = "(Optional) The Connection String for linking the Linux Function App to Application Insights."
  default     = null

}

variable "vnet_route_all_enabled" {
  default = true

}

variable "application_insights_key" {
  description = "(Optional) The Instrumentation Key for connecting the Linux Function App to Application Insights"
  default     = null

}
variable "env_vars" {
  type        = map(string)
  description = "The environment variables map"
  default     = {}
}

variable "artifact_url" {
  type        = string
  description = "The url for the artifact to run"
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Status of public network access to the app function"
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

variable "daily_memory_time_quota" {
  type        = number
  description = "The amount of memory in gigabyte-seconds that the application is allowed to consume per day."
  default     = null
}

variable "customer_managed_key_enabled" {
  type        = bool
  description = "A true or false value as to whether encrypt the storage account with customer managed keys or not"
  default     = false
}

/*variable "custom_domain" {
  type = object({
    hostname = string
    certificate = optional(object({
      name = string
      vault = object({
        name           = string
        resource_group = string
      })
    }))
  })
  description = "Map a custom domain with the app service. If you do not pass the certificate, a managed certificate is created by azure"
  default     = null
}*/

variable "backup" {
  type = object({
    backup_sa = object({
      name           = string
      resource_group = string
    })
    enabled = optional(bool)
    schedule = object({
      frequency_interval       = number
      frequency_unit           = string
      start_time               = optional(string)
      retention_period_days    = optional(number)
      keep_at_least_one_backup = optional(bool)
    })
  })
  description = "The backup configuration for the app service. Skip this for the default backup configuration"
  default     = null
}

variable "application_insights_enabled" {
  description = "Use Application Insights for this App Service"
  type        = bool
  default     = true
}

variable "log_analytics_ws" {
  description = "The log analytics workspace to be used for the app insights"
  type = object({
    name           = string
    resource_group = string
  })
  default = null
}

variable "log_analytics_worksapce_id" {
  description = "ID of the default LAW"
  default     = null

}

variable "site_config" {
  type = object({
    always_on                         = optional(bool)
    app_command_line                  = optional(string)
    default_documents                 = optional(list(string))
    ftps_state                        = optional(string)
    health_check_path                 = optional(string)
    health_check_eviction_time_in_min = optional(string)
    http2_enabled                     = optional(string)
    load_balancing_mode               = optional(string)
    app_scale_limit                   = optional(string)
    elastic_instance_minimum          = optional(string)
    pre_warmed_instance_count         = optional(string)
    application_stack                 = optional(map(string))
    app_service_logs = optional(object({
      disk_quota_mb         = number
      retention_period_days = number
    }))
    cidr_restriction = optional(list(object({
      name     = optional(string)
      priority = optional(number)
      action   = optional(string)
      cidr     = optional(string)
      #       headers  = optional(object({}))
    })), [])
    subnet_restriction = optional(list(object({
      name      = optional(string)
      priority  = optional(number)
      action    = optional(string)
      subnet_id = optional(string)
      #       headers   = optional(object({}))
    })), [])
    service_tags_restriction = optional(list(object({
      name        = optional(string)
      priority    = optional(number)
      action      = optional(string)
      service_tag = optional(string)
      #       headers     = optional(object({}))
    })), [])
    default_ip_restriction_action = optional(string)
    cors = optional(object({
      allowed_origins     = optional(list(string))
      support_credentials = optional(bool)
    }))
  })
  default     = {}
  description = "Site config for App Service."
}

variable "connection_strings" {
  description = "Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}

variable "private_dns_zone_id" {
  type        = string
  description = "ID of the private dns zone for private link"
}


variable "private_dns_zone_name" {
  type        = string
  description = "Name of the private dns zone for private link"
  default     = null
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

variable "create_fileshare" {
  type        = bool
  description = "Do you require a fileshare to be created?"
  default     = false
}

variable "privatelink_funcapp_subnet" {
  type = object({
    name           = string
    vnet_name      = string
    resource_group = string
  })
  description = "Subnet where the private link is required for the function app"
  default     = null
}

variable "func_app_private_dns_zone_id" {
  description = "The private dns zone id for the functio napps"

}

variable "file_share_private_dns_zone_id" {
  description = "The private dns zone for the Azure File Share"
  default     = null
}

 variable "file_share_name" {
  description = "Name of the file share for the function app"
  type        = string
  default     = null
 }

variable "file_share_quota" {
  default = 100

}

variable "file_shares" {
  description = "List of file shares to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "kv_name" {
  description = "The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created"
  type        = string
  default     = null
}

variable "cmk_name" {
  description = "The customer managed key name to be passed into the keyvault"
  default     = null
}

variable "kv_resource_group_name" {
  type        = string
  description = "Resource group name of Azure Container Registry"
  default     = null
}

variable "storage_use" {
  description = "This variables will help to determine which storage account the managed ideneity is for. For example 'func', 'statefile'."
  type        = string
}