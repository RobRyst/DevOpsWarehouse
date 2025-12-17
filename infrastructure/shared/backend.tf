terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateYOURUNIQUE"
    container_name       = "tfstate"
    key                  = "smartinventory-dev.tfstate"
  }
}
