variable "location" {
  description = "Azure location."
  type        = string
  default     = "uaenorth"
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
  default     = "uan"
}


variable "environment" {
  description = "Project environment"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "sku" {
  type        = string
  default     = "standard"
  description = "The SKU which should be used for this Search Service. Possible values are `basic`, `free`, `standard`, `standard2` and `standard3`."
}

variable "tags" {
  description = "The tags for the resource"

}

variable "replica_count" {
  type        = number
  default     = 3 # 3 or more replicas for high availability of read-write workloads (queries and indexing)
  description = "Instances of the search service, used primarily to load balance query operations. Each replica always hosts one copy of an index"
}

variable "partition_count" {
  type        = number
  default     = 1
  description = "Provides index storage and I/O for read/write operations (for example, when rebuilding or refreshing an index)."
}

variable "semantic_search_sku" {
  type        = string
  default     = null
  description = "Specifies the Semantic Search SKU which should be used for this Search Service."
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of IPs or CIDRs to allow for service access"
  default     = []
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this resource."
  default     = false
}

variable "query_keys" {
  description = "Names of the query keys to create"
  type        = list(string)
  default     = []
}

variable "authentication_failure_mode" {
  description = "Specifies the response that the Search Service should return for requests that fail authentication (possible values are `null`, `http401WithBearerChallenge` or `http403`)"
  type        = string
  default     = "http403"
  validation {
    condition     = var.authentication_failure_mode == null || contains(["http401WithBearerChallenge", "http403"], try(var.authentication_failure_mode, ""))
    error_message = "`authentication_failure_mode` variable must be either `null`, `http401WithBearerChallenge` or `http403`."
  }
}

variable "ad_authentication_enabled" {
  description = "Whether Azure Active Directory authentication is enabled."
  type        = bool
  default     = true
  nullable    = false
}

variable "local_authentication_enabled" {
  description = "Whether API key authentication is enabled."

  type     = bool
  default  = true
  nullable = true
}


variable "terraform_timeouts" {
  description = "(Optional) Allows to specify timeouts for certain Terraform actions (create, read, update, delete)."
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "search_service_name" {
  description = "This is the name of the search service"

}

variable "search_service_id" {
  description = "This is the id of the search service"
  type  = string
}

variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Extra tags to set on each created resource."
  type        = map(string)
  default     = {}
}

variable "resource_location" {
  type        = string
  description = "location of Cognative vault"
  default     = "uaenorth"
}

variable "application_name" {
  type        = string
  description = "The application that requires this resource"
}

variable "ai_monitoring" {
  description = "The log analytics workspace to be used for the ai metrics monitoring"
  type = object({
    enabled = bool
    log_analytics_ws = optional(object({
      name           = string
      resource_group = string
    }))
  })
  default  =  {
    enabled  = false
  }
}