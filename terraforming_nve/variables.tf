variable "ENV_NAME" {}
variable "nve_hostname" {}
variable "nve_initial_password" {
    default = "Change_Me12345_"
}

variable "nve_data_disks" {
    type = list(string)
    default =  ["600"]
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



variable "nve_private_ip" {
  type        = string
  description = "IP for NVE instance"
  default     = "10.10.8.10"
}

variable "NVE_IMAGE" {
    type = map
    default = {
        publisher =  "dellemc"
        offer = "dell-emc-networker-virtual-edition"
        sku = "dell-emc-networker-virtual-edition"
        version = "19.4.25"
    }
}
variable "nve_vm_size" {
  type    = string
  default = "Standard_D8s_v3"
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

