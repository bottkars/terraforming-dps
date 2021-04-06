variable "ENV_NAME" {}
variable "ave_hostname" {}
variable "ave_initial_password" {
    default = "Change_Me12345_"
}

variable "ave_gsan_disks" {
    default =  ["250","250","250"]
}
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



variable "ave_private_ip" {
  type        = string
  description = "IP for AVE instance"
  default     = "10.10.8.5"
}

variable "AVE_IMAGE" {
    type = map
    default = {
        publisher =  "dellemc"
        offer = "dell-emc-avamar-virtual-edition"
        sku = "avamar-virtual-edition-1930"
        version = "19.3.01"
    }
}
variable "ave_vm_size" {
  type    = string
  default = "Standard_A5"
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

