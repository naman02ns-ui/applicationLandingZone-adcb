variable "management_sub_id" {
  type = string
}

variable "resource_location" {
  type        = string
  description = "location of ACE"
  default     = "uaenorth"
}

variable "resource_group_name" {
  type        = string
  description = "resource group name of key vault"
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
    error_message = "Allowed values for environment: dev,qa,uat,sit,prod"
  }
}

variable "subnet" {
  type = object({
    name           = string
    vnet_name      = string
    resource_group = string
  })
  description = "Subnet for the container app environment"
  default     = null
}

variable "workload_profile" {
  description = "Workload Profile for container app environment"
  type = object({
    name                  = string
    workload_profile_type = string
  })
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace for container app environment"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "User defined extra tags to be added to all resources created in the module"
}