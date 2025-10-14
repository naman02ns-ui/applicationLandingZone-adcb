terraform {
  required_version = "~> 1.6.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70, < 5.0"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.6.0"
    }
  }
}