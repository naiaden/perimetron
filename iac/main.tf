terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "naiadentfstate"
    container_name       = "tfstate"
    key                  = "perimetron.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.91.0"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

resource "azurerm_resource_group" "readings" {
  name     = "meter-values"
  location = "West Europe"
}

# Shared access keys are enabled for now,
# as only blobs and queues can use only aad auth
# tables and files can only use keys (for now)
resource "azurerm_storage_account" "readings" {
  name                     = "metervalues"
  resource_group_name      = azurerm_resource_group.readings.name
  location                 = azurerm_resource_group.readings.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_table" "manualreadings" {
  name                 = "manualreadings"
  storage_account_name = azurerm_storage_account.readings.name
}