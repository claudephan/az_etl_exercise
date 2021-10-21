resource "azurerm_linux_virtual_machine" "sensietlvm1988" {
    name                = "sensietlvm1988"
    resource_group_name = var.etl_rg.name
    location            = var.etl_rg.location
    size                = "Standard_F2"
    admin_username      = "${var.etl_vm_un}"
    admin_password      = "${var.etl_vm_pw}"
    disable_password_authentication = false
    network_interface_ids = [
        azurerm_network_interface.sensi_etl_nic1988.id,
    ]
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    provisioner "file" {
        connection {
            type = "ssh"
            host = "${azurerm_public_ip.sensi_etl_publicip.ip_address}"
            user = "${var.etl_vm_un}"
            password = "${var.etl_vm_pw}"
        }

        source = "../images/train"
        destination = "/tmp/train"
    }

    provisioner "file" {
        connection {
            type = "ssh"
            host = "${azurerm_public_ip.sensi_etl_publicip.ip_address}"
            user = "${var.etl_vm_un}"
            password = "${var.etl_vm_pw}"
        }

        source = "../image_processor.py"
        destination = "/tmp/image_processor.py"
    }

    provisioner "file" {
        connection {
            type = "ssh"
            host = "${azurerm_public_ip.sensi_etl_publicip.ip_address}"
            user = "${var.etl_vm_un}"
            password = "${var.etl_vm_pw}"
        }

        source = "../requirements.txt"
        destination = "/tmp/requirements.txt"
    }

    provisioner "remote-exec" {
        connection {
            type = "ssh"
            host = "${azurerm_public_ip.sensi_etl_publicip.ip_address}"
            user = "${var.etl_vm_un}"
            password = "${var.etl_vm_pw}"
        }

        inline = [
            "sudo apt-get update",
            "sudo apt-get -y install python3-pip",
            "pip3 install --upgrade pip",
            "sudo pip3 install -r /tmp/requirements.txt",
            "sudo apt-get -y install libsm6",
            "sudo apt-get -y install libxrender-dev",
            "export BASE_PATH=${var.base_path}",
            "cd /tmp/ && python3 image_processor.py",
            
        ]
    }

  depends_on = [azurerm_network_interface.sensi_etl_nic1988]
}


# connection_string = azurerm_storage_account.example.primary_connection_string

# Create the BlobServiceClient object which will be used to create a container client
# blob_service_client = BlobServiceClient.from_connection_string(connect_str)

# # Create a local directory to hold blob data
# local_path = "./data"
# os.mkdir(local_path)

# # Create a file in the local data directory to upload and download
# local_file_name = str(uuid.uuid4()) + ".txt"
# upload_file_path = os.path.join(local_path, local_file_name)

# # Write text to the file
# file = open(upload_file_path, 'w')
# file.write("Hello, World!")
# file.close()

# # Create a blob client using the local file name as the name for the blob
# blob_client = blob_service_client.get_blob_client(container=container_name, blob=local_file_name)

# print("\nUploading to Azure Storage as blob:\n\t" + local_file_name)

# # Upload the created file
# with open(upload_file_path, "rb") as data:
#     blob_client.upload_blob(data)
