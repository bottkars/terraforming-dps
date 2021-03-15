variable "ENV_NAME" {}
variable "PPDM_INITIAL_PASSWORD" {
    default = "Change_Me12345_"
}

variable "PPDM_META_DISKS" {
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
### ppdm starts here
variable "PPDM_HOSTNAME" {}


variable "ppdm_private_ip" {
  type        = string
  description = "IP for ppdm instance"
  default     = "10.10.8.4"
}

variable "PPDM_PUBLIC_IP" {
  type    = string
  default = "false"
}

variable "PPDM_IMAGE" {
    type = map
#    default = {
#        publisher =  "dellemc"
 #       offer = "dell-emc-datadomain-virtual-edition-v4"
 #       sku = "ppdm-60-ver-7305"
 #       version = "7.3.05"
 #   }
}
variable "PPDM_VM_SIZE" {
  type    = string
  default = "Standard_F8s_v2"
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

