variable "resource_location" {
  type        = string
  description = "Region for the backup vault"
  default     = "uaenorth"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group for the backup vault"
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

variable "offer_type" {
  type        = string
  description = "Specifies the Offer Type to use for this CosmosDB Account - currently this can only be set to Standard."
  default     = "Standard"
}

variable "kind" {
  type        = string
  description = "Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`."
  default     = "MongoDB"
}

variable "free_tier_enabled" {
  description = "Enable the option to opt-in for the free database account within subscription."
  type        = bool
  default     = false
}

variable "analytical_storage_enabled" {
  description = "Enable Analytical Storage option for this Cosmos DB account. Defaults to `false`. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "analytical_storage_type" {
  description = "The schema type of the Analytical Storage for this Cosmos DB account. Possible values are `FullFidelity` and `WellDefined`."
  type        = string
  default     = null

  validation {
    condition     = try(contains(["FullFidelity", "WellDefined"], var.analytical_storage_type), true)
    error_message = "The `analytical_storage_type` value must be valid. Possible values are `FullFidelity` and `WellDefined`."
  }
}

variable "mongo_server_version" {
  description = "The Server Version of a MongoDB account. See possible values https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account#mongo_server_version"
  type        = string
  default     = "4.2"
}

variable "consistency_policy" {
  type = object({
    consistency_level       = string
    max_interval_in_seconds = optional(number)
    max_staleness_prefix    = optional(number)
  })
  description = "Consistency levels in Azure Cosmos DB"
  default = {
    consistency_level = "BoundedStaleness"
  }
}

variable "failover_locations" {
  type = list(object(
    {
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool)
    }
  ))
  description = "The name of the Azure region to host replicated data and their priority."
  default     = null
}

variable "capabilities" {
  type        = list(string)
  description = "Configures the capabilities to enable for this Cosmos DB account. Possible values are `AllowSelfServeUpgradeToMongo36`, `DisableRateLimitingResponses`, `EnableAggregationPipeline`, `EnableCassandra`, `EnableGremlin`, `EnableMongo`, `EnableTable`, `EnableServerless`, `MongoDBv3.4` and `mongoEnableDocLevelTTL`."
  default     = ["EnableMongo"]
}

variable "allowed_cidrs" {
  type        = set(string)
  description = "CosmosDB Firewall Support: This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account."
  default     = []
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for this CosmosDB account."
  type        = bool
  default     = false
}

variable "is_virtual_network_filter_enabled" {
  description = "Enables virtual network filtering for this Cosmos DB account"
  type        = bool
  default     = false
}

variable "network_acl_bypass_for_azure_services" {
  description = "If azure services can bypass ACLs."
  type        = bool
  default     = false
}

variable "network_acl_bypass_ids" {
  description = "The list of resource Ids for Network Acl Bypass for this Cosmos DB account."
  type        = list(string)
  default     = null
}

variable "virtual_network_rule" {
  description = "Specifies a virtual_network_rules resource used to define which subnets are allowed to access this CosmosDB account"
  type = list(object({
    id                                   = string,
    ignore_missing_vnet_service_endpoint = bool
  }))
  default = null
}

variable "backup" {
  description = "Backup block with type (Continuous / Periodic), interval_in_minutes, retention_in_hours keys and storage_redundancy"
  type = object({
    type                = string
    interval_in_minutes = number
    retention_in_hours  = number
    storage_redundancy  = string
  })
  default = null
}

variable "managed_identity" {
  type        = bool
  description = "Specifies the type of Managed Service Identity that should be configured on this Cosmos Account. Possible value is only SystemAssigned. Defaults to false."
  default     = true
}

variable "identity_ids" {
  type        = string
  description = "The identtiy ids to be attached to the cosmos db"
  default     = null

}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "databases" {
  description = "MongoDB Databases"
  type = map(object({
    description    = optional(string)
    throughput     = optional(number)
    max_throughput = optional(number)
    collections = list(object({
      name           = string
      shard_key      = string
      throughput     = optional(number)
      max_throughput = optional(number)
    }))
  }))
  default = {}
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["Requests"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
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