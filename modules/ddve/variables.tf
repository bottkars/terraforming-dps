# ==================== Variables

variable "env_name" {
  default = ""
}
variable "ddve_initial_password" {}

variable "location" {
  default = ""
}
variable "ddve_meta_disk_size" {
    default = 1023
}
variable "ddve_meta_disks" {
    default =  ["1","2","3"]
}
#{
#  default = [
#    {
#      number = 1
#    },
#    {
#      number = 2
#    },
#  ]
#}

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
  default = "ddve"
}