# Variables for Cosmos DB Module

# Basic Configuration Variables
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = ""
}

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

variable "application_name" {
  description = "Name of the application"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for Cosmos DB."
  type        = string
}

variable "location" {
  description = "Azure region for Cosmos DB."
  type        = string
}

variable "cosmosdb_account_name" {
  description = "Name of the Cosmos DB account."
  type        = string
}

variable "kind" {
  description = "The kind of CosmosDB to create (e.g., MongoDB, GlobalDocumentDB)."
  type        = string
  default     = "GlobalDocumentDB"
}

variable "offer_type" {
  description = "The offer type for Cosmos DB."
  type        = string
  default     = "Standard"
}

# Advanced Configuration
variable "enable_automatic_failover" {
  description = "Enable automatic failover for this Cosmos DB account."
  type        = bool
  default     = false
}

variable "enable_multiple_write_locations" {
  description = "Enable multiple write locations for this Cosmos DB account."
  type        = bool
  default     = false
}

variable "enable_virtual_network_filter" {
  description = "Enable virtual network filtering for this Cosmos DB account."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether or not public network traffic is allowed for this CosmosDB account."
  type        = bool
  default     = false
}

variable "analytical_storage_enabled" {
  description = "Enable Analytical Storage option for this Cosmos DB account."
  type        = bool
  default     = false
}

variable "analytical_storage_schema_type" {
  description = "The schema type of the Analytical Storage for this Cosmos DB account."
  type        = string
  default     = "WellDefined"
}

# Consistency Policy
variable "consistency_policy" {
  description = "Consistency policy for the CosmosDB account."
  type = object({
    consistency_level       = string
    max_interval_in_seconds = optional(number)
    max_staleness_prefix    = optional(number)
  })
  default = {
    consistency_level = "Session"
  }
}

# Geo Location
variable "geo_location" {
  description = "List of geo locations for the CosmosDB account."
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool)
  }))
  default = []
}

# Capabilities
variable "capabilities" {
  description = "List of capabilities to enable for this CosmosDB account."
  type        = list(string)
  default     = ["EnableServerless"]
}

# Networking
variable "virtual_network_rules" {
  description = "List of virtual network rules for the CosmosDB account."
  type = list(object({
    subnet_id                               = string
    ignore_missing_vnet_service_endpoint    = optional(bool)
  }))
  default = null
}

# Backup Configuration
variable "backup" {
  description = "Backup configuration for the CosmosDB account."
  type = object({
    type                = string
    tier                = optional(string)
    interval_in_minutes = optional(number)
    retention_in_hours  = optional(number)
    storage_redundancy  = optional(string)
  })
  default = null
}

# CORS Configuration
variable "cors_rule" {
  description = "CORS rule for the CosmosDB account."
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
}

# Identity Configuration
variable "identity" {
  description = "Identity configuration for the CosmosDB account."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

# SQL Databases
variable "sql_databases" {
  description = "List of SQL databases to create."
  type = list(object({
    name = string
    autoscale_settings = optional(object({
      max_throughput = number
    }))
    throughput = optional(number)
  }))
  default = []
}

# SQL Containers
variable "sql_containers" {
  description = "List of SQL containers to create."
  type = list(object({
    name               = string
    database_name      = string
    partition_key_path = string
    autoscale_settings = optional(object({
      max_throughput = number
    }))
    throughput = optional(number)
    unique_keys = optional(list(object({
      paths = list(string)
    })))
    indexing_policy = optional(object({
      indexing_mode    = string
      included_paths   = optional(list(string))
      excluded_paths   = optional(list(string))
      composite_indexes = optional(list(object({
        indexes = list(object({
          path  = string
          order = string
        }))
      })))
      spatial_indexes = optional(list(object({
        path  = string
        types = list(string)
      })))
    }))
  }))
  default = []
}

# Private Endpoint Configuration
variable "enable_private_endpoint" {
  description = "Enable private endpoint for Cosmos DB."
  type        = bool
  default     = false
}

variable "privatelink_subnet" {
  description = "Subnet configuration for private endpoint."
  type = object({
    name                 = string
    vnet_name           = string
    resource_group      = string
  })
  default = null
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs for private endpoint."
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
