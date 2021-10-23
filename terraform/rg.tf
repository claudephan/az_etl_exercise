#Create Azure Resource Group
resource "azurerm_resource_group" "etl_learn_rg" {
  name     = var.etl_rg.name
  location = var.etl_rg.location
}