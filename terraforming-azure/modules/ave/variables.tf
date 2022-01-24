# ==================== Variables
variable ave_instance {}
variable "environment" {
  default = ""
}
variable "ave_initial_password" {}
variable "public_ip" {
  type    = string
  default = "false"
}
variable "location" {
  default = ""
}

variable "ave_tcp_outbound_rules" {
    default =  ["7","22","25","111","161","163","443","700","2049","2052","3008","3009","8443","8888","9090","9443","2700","28001-28002","28810-28819","29000","30001-30010"]
}

variable "ave_udp_outbound_rules" {
    default =  ["53","111","161","163","2049","2052"]
}

variable "ave_tcp_inbound_rules" {
    default =  ["22","161","163","443","7543","700","7778-7781","8543","9090","9443","2700","28001-28002","28810-28819","29000","30001-30010"]
}
variable "ave_gsan_disks" {
    default =  ["1000","250","250"]
}

variable "AVE_IMAGE" {
  type = map
}
variable "ave_private_ip" {
  default = ""
}

variable "ave_image_uri" {
  default = ""
}

variable "ave_vm_size" {
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

variable "ave_disk_type" {
  default = "Standard_LRS"
}

resource random_string "ave_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "tls_private_key" "ave" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

locals {
  # ave_vm          = "${var.ave_image_uri == "" ? 0 : 1}"
    ave_vm          = "1"

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
  type    = list
  default = []
}

variable "infrastructure_subnet" {
  default = ""
}

variable "ave_hostname" {
  default = "ave"
}

