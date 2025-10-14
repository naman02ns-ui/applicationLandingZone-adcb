variable "resource_location" {
  type        = string
  description = "location of container"
  default     = "uaenorth"
}


variable "resource_group_name" {
  type        = string
  description = "The resource group for the Container Environment"
}

variable "application_name" {
  type        = string
  description = "The application that requires this resource"
}

variable "environment" {
  type        = string
  description = "Environment where Container Environment is provisioned"
  validation {
    condition     = can(regex("^(?:dev|qa|sit|uat|preprod|prod)$", var.environment))
    error_message = "Allowed values for environment: dev,qa,uat,sit,preprod,prod"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to be added to the resources"
}

variable "registry" {
  description = "The name of Container Registry"
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "container_app_environment_id" {
  description = "ID of the Container App Env"
  type        = string
}

variable "ingress_external_enabled" {
  description = "Whether ingress is externally accessible"
  type        = bool
  default     = false
}

variable "ingress_target_port" {
  description = "Target port for ingress traffic"
  type        = number
}

variable "ingress_transport" {
  description = "Ingress transport protocol (auto, http, http2)"
  type        = string
  default     = "auto"
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "workload_profile_name" {
  default = "Consumption"

}

variable "container_config" {
  description = "Container configuration for the container app"
  type = object({
    name   = string
    cpu    = string
    memory = string
    image  = string
  })
}

variable "revision_mode" {
  description = "Container configuration for the container app"
  type = string
  default = "Single"
}

variable "external_identity_ids" {
  description = "List of identity ids to be passed onto the container app."
  type        = list(string)
  default = []

}