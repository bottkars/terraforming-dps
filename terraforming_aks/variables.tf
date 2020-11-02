variable "env_name" {}

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

variable "ppdm_hostname" {
  default = ""
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

variable "k8s_pool_node_count" {
    default = "2"
    }
variable "k8s_pool_node_size" {
    default = "Standard_D2_v2"
    }