variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_location" {
  description = "The Azure region where the Application Insights will be created"
  type        = string
}

variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "environment" {
  description = "The environment (dev, test, prod)"
  type        = string
}

variable "application_type" {
  description = "Specifies the type of Application Insights to create"
  type        = string
  default     = "web"
}

variable "workspace_id" {
  description = "Specifies the id of a log analytics workspace resource"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}