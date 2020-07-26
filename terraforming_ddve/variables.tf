variable "env_name" {}
variable "ddve_hostname" {}
variable "ddve_initial_password" {
    default = "Change_Me12345_"
}
variable "ddve_meta_disk_size" {
    default = 1023
}
variable "ddve_meta_disks" {
    default =  ["1","2"]
}
variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

#### use this block if not using ENV Vars:
#variable "subscription_id" {}

#variable "tenant_id" {}

#variable "client_id" {}

#variable "client_secret" {}

variable "location" {}



variable "ddve_private_ip" {
  type        = string
  description = "IP for DDVE instance"
  default     = "10.0.8.4"
}

variable "ddve_image" {
    type = map
    default = {
        publisher =  "dellemc"
        offer = "dell-emc-datadomain-virtual-edition-v4"
        sku = "ddve-50-ver-72005"
        version = "7.2.05"
    }
}
variable "ddve_vm_size" {
  type    = string
  default = "Standard_DS4_v2"
}

variable "dns_suffix" {}




variable "dps_virtual_network_address_space" {
  type    = list
  default = ["10.0.0.0/16"]
}

variable "dps_infrastructure_subnet" {
  type    = string
  default = "10.0.8.0/26"
}
variable "dps_azure_bastion_subnet" {
  type    = string
  default = "10.0.0.224/27"
}
