resource "azurerm_resource_group" "this" {
  name     = "rg-smartinv-dev"
  location = "westeurope"
}

module "network" {
  source          = "../../modules/network"
  rg_name         = azurerm_resource_group.this.name
  location        = azurerm_resource_group.this.location
  vnet_name       = "vnet-smartinv-dev"
  vnet_cidr       = "10.10.0.0/16"
  aks_subnet_cidr = "10.10.1.0/24"
}

module "aks" {
  source     = "../../modules/aks"
  rg_name    = azurerm_resource_group.this.name
  location   = azurerm_resource_group.this.location
  aks_name   = "aks-smartinv-dev"
  subnet_id  = module.network.aks_subnet_id
  node_count = 2
  vm_size    = "Standard_B2s"
}

module "database" {
  source      = "../../modules/database"
  rg_name     = azurerm_resource_group.this.name
  location    = azurerm_resource_group.this.location
  cosmos_name = "cosmos-smartinv-dev-ryzta-001"
}
