terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.56.0"
    }
  }

backend "azurerm" {
  resource_group_name  = "rg-tfstate"
  storage_account_name = "sttfstate457204"
  container_name       = "tfstate"
  key                  = "smartinventory-dev.tfstate"
}
}

provider "azurerm" {
  features {}
  subscription_id = "8d6265da-a014-42d5-8c4f-ba763f57d013"
}

