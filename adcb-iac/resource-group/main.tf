locals {
  tags      = var.tags
  }

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags = local.tags
}

output "rg_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "rg_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.rg.location
}

output "rg_id" {
  value = azurerm_resource_group.rg.id
}

variable "rg_name" {
  description = "(Mandatory) Name of the resource group"
  type        = string
}

variable "location" {
  description = "(Optional) Azure Location"
  type        = string
  default     = "uaenorth"
}

variable "tags" {
  description = "(Optional) Resource Tags"
  type        = map(string)
}

terraform {
  required_version = "~> 1.6.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70, < 5.0"
    }
  }
}
