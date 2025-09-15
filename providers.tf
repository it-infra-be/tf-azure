terraform {
  required_version = "~> 1.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.41"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
