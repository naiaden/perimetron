resource "azurerm_resource_group" "readings" {
  name = "meter-values"
  location = "West Europe"
}

resource "azurerm_storage_account" "readings" {
  name = "meter-values"
  resource_group_name = azurerm_resource_group.readings.name
  location = azurerm_resource_group.readings.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_table" "manualreadings" {
    name = "manual-readings"
    storage_account_name = azurerm_storage_account.readings.name
}