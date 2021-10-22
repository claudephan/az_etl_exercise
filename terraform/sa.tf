locals {
    today              = timestamp()
    tomorrow           = timeadd(local.today, "24h")
}

resource "azurerm_storage_account" "sensietlstorage1988" {
  name                     = "sensietlstorage1988"
  location                 = azurerm_resource_group.etl_learn_rg.location
  resource_group_name      = azurerm_resource_group.etl_learn_rg.name
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
  depends_on = [azurerm_resource_group.etl_learn_rg]
}

resource "azurerm_storage_container" "storage_container" {
    name                  = "images"
    storage_account_name  = azurerm_storage_account.sensietlstorage1988.name
    container_access_type = "private" 
}

data "azurerm_storage_account_blob_container_sas" "blob_container_sas" {
    connection_string = azurerm_storage_account.sensietlstorage1988.primary_connection_string
    container_name    = azurerm_storage_container.storage_container.name
    https_only        = true

    start  = local.today
    expiry = local.tomorrow

    permissions {
        read   = true
        add    = false
        create = false
        write  = false
        delete = false
        list   = true
    }

    depends_on = [
        azurerm_storage_container.storage_container
    ]
}

output "sas_url_query_string" {
    value = nonsensitive(data.azurerm_storage_account_blob_container_sas.blob_container_sas.sas)
    description = "This is the SAS needed to download processed images from Storage Container"
    depends_on = [
        data.azurerm_storage_account_blob_container_sas.blob_container_sas
    ]
}

output "storage_container_id" {
    value = azurerm_storage_container.storage_container.id
    description = "This is the Storage Container URL"
}