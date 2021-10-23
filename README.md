## Description of the project:
### Preferable environment to be used is: MS Azure.
### Come up with Python based data processing pipeline with data preparation & processing functional workflow steps as follows : 
1. Load an image dataset from Laptop to Azure compute instance
    - Run following transformation on the data (each image)
        - Flip the image horizontally and vertically
        - Rotate it by 30 degrees
        - Blur it by 25% and 50%
    - Store the transformed images into an output folder.
    - Describe an easy way to visualize the output data.
 

2. Publish the above pipeline application to be used by others in the public cloud environment with proper deployment instructions.
    - Deployment instructions should cover scripted way to bring up infra in the cloud (VMs and storage etc..)
    - Suggest DevOps best practices to be followed while deploying pipeline.

3. Provide what kind of improvements and feature enhancement can be done on top of initial pipeline functionality. 

### Overview
1. Terraform will create:
    - Azure resource group
    - tls public & private keys 
    - Networking (vnet, subnet, public ip, network interface card, network security group)
    - Storage (account, container, blob shared access signature)
    - Compute VM
        - Will ssh images, python script, and requirments.txt to VM
        - Will run a sequence of remote commands to prepare the VM
            - install python pip
            - install python packages
            - set enviorment variables
            - run python script
2. image_processing.py
    - Main script for image processing and pushing processed images into Azure Storage Container


### Prerequisites
1. Terraform (>= v1.0.3)
2. azcopy
3. Azure subscription
### Deployment Instructions
1. az login ("az account show" to verify correct account has been logged in)
    - Enable Azure providers (Might not be needed if not on free tier)
        - az provider register --namespace Microsoft.Network
        - az provider register --namespace Microsoft.Compute
        - az provider register --namespace Microsoft.Storage
2. cd terraform
3. terraform init
4. terraform plan -out etlrun.tfplan
5. terraform apply etlrun.tfplan
    - Upon successful run terraform will output an az copy command which can be used to download images from storage container
6. (Optional) Copy processed images from storage container to local disk
    - azcopy cp "${storage_container_id}${sas_url_query_string}" "local/path" --recursive=true

## DevOps Best Practices
1. Would want somewhere to store and manage terraform statefiles
2. Version control/release versioning of this pipeline code in SCM with branching stratrgy
3. Auto triggering or scheduled batch processing can always pull latest pipeline code from SCM
4. Depending on service/use case, can spin down resources after process is completed

## Improvements & Future Enhancements
1. Deployment time is extended because terraform is starting with basic 18.04 Ubuntu image and setting up python packages on top of it. Can either use a tool such as HashiCorp's packer.io to build out preloaded base images with necessary infrastucture configurations already set. Or run image processing in a container.
2. Ideally the initial images to be processed wouldnt be trasfered into the VM from local disk. Images would probably be available in some object store/data lake populated from an ETL pipeline/job.
3. Base on scale & resources, could be possible to run image processing functions async.
4. Better structured terraform, code taking advantage patterens such as modules for code reusability