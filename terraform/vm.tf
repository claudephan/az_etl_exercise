resource "azurerm_linux_virtual_machine" "sensietlvm1988" {
    name                = "sensietlvm1988"
    location            = azurerm_resource_group.etl_learn_rg.location
    resource_group_name = azurerm_resource_group.etl_learn_rg.name
    size                = "Standard_F2"
    admin_username      = "${var.etl_vm_un}"
    # admin_password      = "${var.etl_vm_pw}"
    disable_password_authentication = true
    network_interface_ids = [
        azurerm_network_interface.sensi_etl_nic1988.id,
    ]

    admin_ssh_key {
        username   = "${var.etl_vm_un}"
        public_key = "${tls_private_key.vm_ssh.public_key_openssh}"
    }

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
            # password = "${var.etl_vm_pw}"
            private_key = "${tls_private_key.vm_ssh.private_key_pem}"
        }

        source = "../images/train"
        destination = "/tmp/train"
    }

    provisioner "file" {
        connection {
            type = "ssh"
            host = "${azurerm_public_ip.sensi_etl_publicip.ip_address}"
            user = "${var.etl_vm_un}"
            # password = "${var.etl_vm_pw}"
            private_key = "${tls_private_key.vm_ssh.private_key_pem}"
        }

        source = "../image_processor.py"
        destination = "/tmp/image_processor.py"
    }

    provisioner "file" {
        connection {
            type = "ssh"
            host = "${azurerm_public_ip.sensi_etl_publicip.ip_address}"
            user = "${var.etl_vm_un}"
            # password = "${var.etl_vm_pw}"
            private_key = "${tls_private_key.vm_ssh.private_key_pem}"
        }

        source = "../requirements.txt"
        destination = "/tmp/requirements.txt"
    }

    provisioner "remote-exec" {
        connection {
            type = "ssh"
            host = "${azurerm_public_ip.sensi_etl_publicip.ip_address}"
            user = "${var.etl_vm_un}"
            # password = "${var.etl_vm_pw}"
            private_key = "${tls_private_key.vm_ssh.private_key_pem}"
        }

        inline = [
            "sudo apt-get update",
            "sudo apt-get -y install python3-pip",
            "pip3 install --upgrade pip",
            "sudo pip3 install -r /tmp/requirements.txt",
            "sudo apt-get -y install libsm6",
            "sudo apt-get -y install libxrender-dev",
            "export BASE_PATH=${var.base_path}",
            "export AZURE_STORAGE_CONNECTION_STRING='${azurerm_storage_account.sensietlstorage1988.primary_connection_string}'",
            "export CONTAINER_NAME=${azurerm_storage_container.storage_container.name}",
            "cd /tmp/ && python3 image_processor.py",
            
        ]
    }

  depends_on = [azurerm_network_interface.sensi_etl_nic1988]
}

