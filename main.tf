resource "azurerm_storage_account" "example" {
  name                     = "storagetestcreategit"
  resource_group_name      = "rg-bongiorno-weu-001"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
