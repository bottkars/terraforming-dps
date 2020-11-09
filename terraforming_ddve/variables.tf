variable "ENV_NAME" {}
variable "DDVE_INITIAL_PASSWORD" {
    default = "Change_Me12345_"
}

variable "DDVE_META_DISKS" {
    type = list(string)
    default =  ["1023","250","250"]
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
## ddve starts here
variable "DDVE_HOSTNAME" {}

variable "PPDM_HOSTNAME" {
  default = ""
}

variable "ddve_ppdd_nfs_path" {
  default = "/data/col1/powerprotect"
}

variable "ddve_private_ip" {
  type        = string
  description = "IP for ddve instance"
  default     = "10.10.8.4"
}

variable "DDVE_PUBLIC_IP" {
  type    = string
  default = "false"
}

variable "DDVE_IMAGE" {
    type = map
    default = {
        publisher =  "dellemc"
        offer = "dell-emc-datadomain-virtual-edition-v4"
        sku = "ddve-60-ver-7305"
        version = "7.3.05"
    }
}
variable "DDVE_VM_SIZE" {
  type    = string
  default = "Standard_DS4_v2"
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

