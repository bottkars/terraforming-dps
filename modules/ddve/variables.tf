# ==================== Variables

variable "env_name" {
  default = ""
}
variable "ddve_initial_password" {}

variable "location" {
  default = ""
}

variable "ddve_meta_disks" {
    default =  ["1000","250","250"]
}


variable "resource_group_name" {
  default = ""
}

variable "ddve_ppdd_nfs_client" {
  default = ""
}

variable "ddve_ppdd_nfs_path" {
  default = ""
}


variable "ddve_tcp_inbound_rules_Vnet" {
    default =  ["22","2049","2051","3009"]
}
variable "ddve_tcp_inbound_rules_Inet" {
    default =  ["443"]
}
variable "public_ip" {
  type    = string
  default = "false"
}
variable "ddve_image" {
  type = map
}
variable "ddve_private_ip" {
  default = ""
}

variable "ddve_image_uri" {
  default = ""
}

variable "ddve_vm_size" {
  default = ""
}


variable "subnet_id" {
  default = ""
}

variable "dns_zone_name" {
  default = ""
}

variable "ddve_disk_type" {
  default = "Standard_LRS"
}

resource random_string "ddve_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "tls_private_key" "ddve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

locals {
  # ddve_vm          = "${var.ddve_image_uri == "" ? 0 : 1}"
    ddve_vm          = "1"

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

variable "dps_virtual_network_address_space" {
  type    = list
  default = []
}

variable "dps_infrastructure_subnet" {
  default = ""
}

variable "ddve_hostname" {
  default = "ddve{env_name}"
}
