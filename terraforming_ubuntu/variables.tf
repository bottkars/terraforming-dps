variable "ENV_NAME" {}

variable "environment" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

#### use this block if not using ENV Vars:
variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}


variable "linux_hostname" {
  default = "client1"
}
variable "linux_admin_username" {
    default = "ubuntu"
}

variable "linux_data_disks" {
    type = list(string)
    default =  []
}
variable "storage_account_cs" {}
variable "storage_account_key_cs" {}

variable "file_uris_cs" {
  type    = string
}

variable "linux_private_ip" {
  type        = string
  description = "IP for linux instance"
  default     = "10.10.8.12"
}

variable "linux_image" {
    type = map
    default = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
}
variable "linux_vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "dns_suffix" {}


variable "dps_virtual_network_address_space" {
  type    = list
  default = ["10.10.0.0/16"]
}

variable "dps_infrastructure_subnet" {
  type    = string
  default = "10.10.8.0/26"
}
variable "dps_azure_bastion_subnet" {
  type    = string
  default = "10.10.0.224/27"
}

