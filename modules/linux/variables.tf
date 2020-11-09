# ==================== Variables

variable "ENV_NAME" {
  default = ""
}
variable "linux_admin_username" {}
variable "location" {}

variable "linux_tcp_outbound_rules" {
    default =  []
}

variable "linux_udp_outbound_rules" {
    default =  []
}
variable "storage_account" {}
variable "storage_account_key" {}
variable "file_uris" {
}

variable "linux_tcp_inbound_rules_Inet" {
    default =  []
}
variable "linux_tcp_inbound_rules_Vnet" {
    default =  ["9000-9001","8080","22","9090","443","7937-7954"]
}
variable "linux_image" {
  type = map
}
variable "linux_data_disks" {
    default =  []
}
variable "linux_private_ip" {
  default = ""
}

variable "linux_image_uri" {
  default = ""
}

variable "linux_vm_size" {
  default = ""
}

variable "resource_group_name" {
  default = ""
}

variable "security_group_id" {
  default = ""
}


variable "subnet_id" {
  default = ""
}

variable "dns_zone_name" {
  default = ""
}

variable "linux_disk_type" {
  default = "Standard_LRS"
}

resource random_string "linux_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "tls_private_key" "linux" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

locals {
  # linux_vm          = "${var.linux_image_uri == "" ? 0 : 1}"
    linux_vm          = "1"

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

variable "linux_hostname" {
  default = "linux"
}
