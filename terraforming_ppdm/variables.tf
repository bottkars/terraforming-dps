variable "env_name" {}
variable "ppdm_hostname" {}
variable "ppdm_initial_password" {
    default = "Change_Me12345_"
}

variable "ppdm_meta_disks" {
    type = list(string)
    default =  ["488","10","10","5","5","5"]
}
#Standard F8s_v2
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



variable "ppdm_private_ip" {
  type        = string
  description = "IP for ppdm instance"
  default     = "10.0.8.4"
}

variable "ppdm_public_ip" {
  type    = string
  default = "false"
}

variable "ppdm_image" {
    type = map
#    default = {
#        publisher =  "dellemc"
 #       offer = "dell-emc-datadomain-virtual-edition-v4"
 #       sku = "ppdm-60-ver-7305"
 #       version = "7.3.05"
 #   }
}
variable "ppdm_vm_size" {
  type    = string
  default = "Standard_F8s_v2"
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

