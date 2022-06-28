# ==================== Variables
variable "ppdm_instance" {}
variable "environment" {
  default = ""
}
variable "ppdm_initial_password" {
}

variable "location" {
  default = ""
}




variable "resource_group_name" {
  default = ""
}


variable "ppdm_tcp_inbound_rules_Vnet" {
  default = ["22", "2049", "2051", "3009", "443", ]
}
variable "ppdm_tcp_inbound_rules_Inet" {
  default = ["443", "8443"]
}
variable "public_ip" {
  type    = string
  default = "false"
}
variable "ppdm_version" {
  default = "19.10.0"
}

variable "ppdm_image_uri" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "dns_zone_name" {
  default = "example.com"
}

variable "ppdm_disk_type" {
  default = "Standard_LRS"
}



locals {
  # ppdm_vm          = "${var.ppdm_image_uri == "" ? 0 : 1}"
  ppdm_vm = "1"

}

variable "autodelete" {
  default = "true"
}
variable "deployment" {
  default = "test"
}
variable "dns_subdomain" {
  default = ""
}

variable "dns_suffix" {
  default = ""
}

variable "virtual_network_address_space" {
  type    = list(any)
  default = []
}

variable "infrastructure_subnet" {
  default = ""
}
