#Create Virtual Network
resource "azurerm_virtual_network" "sensi_etl_vnet1988" {
    name                = var.etl_vnet_name
    address_space       = ["10.1.0.0/16"]
    location            = azurerm_resource_group.etl_learn_rg.location
    resource_group_name = azurerm_resource_group.etl_learn_rg.name
    
}

#Create Virtual Network Subnet
resource "azurerm_subnet" "sensi_etl_subnet1988" {
    name                 = "sensi_etl_subnet1988"
    resource_group_name  = azurerm_resource_group.etl_learn_rg.name
    virtual_network_name = var.etl_vnet_name
    address_prefixes     = ["10.1.2.0/24"]
    depends_on = [azurerm_virtual_network.sensi_etl_vnet1988]
}

#Create Azure Public IP
resource "azurerm_public_ip" "sensi_etl_publicip" {
    name                         = "sensi_etl_publicip"
    location                     = azurerm_resource_group.etl_learn_rg.location
    resource_group_name          = azurerm_resource_group.etl_learn_rg.name
    allocation_method            = "Static"
    depends_on = [azurerm_resource_group.etl_learn_rg]
}

#Create Azure Network Interface Card for VM
resource "azurerm_network_interface" "sensi_etl_nic1988" {
    name                = "sensi_etl_nic1988"
    location            = azurerm_resource_group.etl_learn_rg.location
    resource_group_name = azurerm_resource_group.etl_learn_rg.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.sensi_etl_subnet1988.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.sensi_etl_publicip.id
    }

    depends_on = [azurerm_subnet.sensi_etl_subnet1988, azurerm_public_ip.sensi_etl_publicip]
}

#Create Network Security Group to allow SSH into vm
resource "azurerm_network_security_group" "sensi_etl_nsg" {
    name                = "sensi_etl_nsg"
    location            = azurerm_resource_group.etl_learn_rg.location
    resource_group_name = azurerm_resource_group.etl_learn_rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    depends_on = [azurerm_virtual_network.sensi_etl_vnet1988]
}