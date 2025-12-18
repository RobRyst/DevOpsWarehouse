resource "azurerm_cosmosdb_account" "this" {
  name                = var.cosmos_name
  location            = "northeurope"
  resource_group_name = var.rg_name
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  public_network_access_enabled = true
}
