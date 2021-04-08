# ==================== Variables

variable "ENV_NAME" {
  default = ""
}
variable "DDVE_INITIAL_PASSWORD" {
  default = "Change_Me12345_"
}

variable "location" {
  default = ""
}

variable "DDVE_META_DISKS" {
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
    default =  ["22","2049","2051","3009","443"]
}
variable "ddve_tcp_inbound_rules_Inet" {
    default =  ["443"]
}
variable "public_ip" {
  type    = string
  default = "false"
}
variable "DDVE_IMAGE" {
  type = map
}
variable "ddve_private_ip" {
  default = ""
}

variable "ddve_image_uri" {
  default = ""
}

variable "DDVE_VM_SIZE" {
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

variable "DDVE_HOSTNAME" {
  default = "ddve{ENV_NAME}"
}
