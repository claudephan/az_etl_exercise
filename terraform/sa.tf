resource "azurerm_storage_account" "sensietlstorage1988" {
  name                     = "sensietlstorage1988"
  resource_group_name      = var.etl_rg.name
  location                 = var.etl_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  enable_https_traffic_only = true
  allow_blob_public_access = true
  min_tls_version = "TLS1_2"
  is_hns_enabled = false
  access_tier = "Hot"
  large_file_share_enabled = false
  
  routing {
    choice = "MicrosoftRouting"
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "storage_container" {
    name                  = "images"
    storage_account_name  = azurerm_storage_account.sensietlstorage1988.name
    container_access_type = "private"
}

# resource "azurerm_storage_blob" "storage_blob" {
#   name                   = "train"
#   storage_account_name   = azurerm_storage_account.sensietlstorage1988.name
#   storage_container_name = azurerm_storage_container.storage_container.name
#   type                   = "Block"
#   source                 = "../images/train/"
# }