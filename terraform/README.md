1. terraform init
2. terraform plan -out etlrun.tfplan
3. terraform apply etlrun.tfplan
    - Upon successful run terraform will output an az copy command which can be used to download images from the storage container
4. (Optional) Copy processed images from the storage container to local disk.
    - azcopy cp "${storage_container_id}${sas_url_query_string}" "local/path" --recursive=true
    - Remember to change value of "Local Path" in command above