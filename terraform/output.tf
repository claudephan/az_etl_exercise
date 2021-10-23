output "azcopy_cmd" {
    value = nonsensitive("azcopy cp '${azurerm_storage_container.storage_container.id}${data.azurerm_storage_account_blob_container_sas.blob_container_sas.sas}' '/local/path/' --recursive=true")
    description = "Command to pull imgaes from storage account"
}

# output "tls_private_key" { 
#     value = tls_private_key.vm_ssh.private_key_pem 
#     sensitive = true
# }