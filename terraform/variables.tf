variable "etl_rg" {
  type = map(string)
  default = {
    name     = "az_etl_learn"
    location = "West US 2"
  }
}

variable "etl_vnet_name" {
  type = string
  default = "sensi_etl_vnet1988"
}

variable "etl_vm_un" {
  type = string
  default = "adminuser"
}

variable "etl_vm_pw" {
  type = string
  default = "Cl@ude123456"
}

variable "base_path" {
  type = string
  default = "."
}