# ==================== Variables

variable "ENV_NAME" {
  default = ""
}
variable "nve_initial_password" {}

variable "location" {
  default = ""
}

variable "nve_tcp_outbound_rules" {
    default =  ["443"]
}

variable "nve_udp_outbound_rules" {
    default =  [""]
}

variable "nve_tcp_inbound_rules_Inet" {
    default =  ["7543"]
}
variable "nve_tcp_inbound_rules_Vnet" {
    default =  ["9000-9001","8080","22","9090","443","7937-7954"]
}
variable "NVE_IMAGE" {
  type = map
}
variable "nve_data_disks" {
    default =  ["600"]
}
variable "nve_private_ip" {
  default = ""
}

variable "nve_image_uri" {
  default = ""
}

variable "nve_vm_size" {
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

variable "nve_disk_type" {
  default = "Standard_LRS"
}

resource random_string "nve_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "tls_private_key" "nve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

locals {
  # nve_vm          = "${var.nve_image_uri == "" ? 0 : 1}"
    nve_vm          = "1"

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

variable "nve_hostname" {
  default = "nve"
}
