terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.2"
    }
  }
}

resource "azurerm_cosmosdb_account" "this" {
  name                = var.cosmos_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = var.cosmos_api

  enable_automatic_failover = var.auto_failover

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.geo_location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "this" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
}

output "account_id" {
  value = azurerm_cosmosdb_account.this.id
  description = "Resource identifier of the instance of CosmosDB account."
}

output "host" {
  value = azurerm_cosmosdb_account.this.endpoint
}

output "port" {
  value = 443
}

output "database" {
  value = azurerm_cosmosdb_mongo_database.this.name
}