terraform {
  required_version = "~>1.6.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70, < 5.0"
    }
  }

  # Commenting out backend for local development
  # backend "azurerm" {
  #   use_oidc = true
  #   use_msi  = true
  #   use_azuread_auth   = true    # https://developer.hashicorp.com/terraform/language/backend/azurerm
  # }
}

provider "azurerm" {
  subscription_id = var.ainonprod_sub_id
  features {}
  # use_msi = true
  # use_oidc = true
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_sub_id
  features {}
  # use_msi = true
  # use_oidc = true
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_sub_id
  features {}
  # use_msi = true
  # use_oidc = true
}