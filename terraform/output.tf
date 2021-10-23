#Text output to the user which will provide azcopy command for downloading processed images from SA
output "azcopy_cmd" {
    value = nonsensitive("azcopy cp '${azurerm_storage_container.storage_container.id}${data.azurerm_storage_account_blob_container_sas.blob_container_sas.sas}' '/local/path/' --recursive=true")
    description = "Command to pull imgaes from storage account"
}

#Output block to show private key incase there is interest in being able to SSH into the VM
# output "tls_private_key" { 
#     value = tls_private_key.vm_ssh.private_key_pem 
#     sensitive = true
# }