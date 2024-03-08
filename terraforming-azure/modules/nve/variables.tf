# ==================== Variables
variable "nve_instance" {}

variable "environment" {
  default = ""
}
variable "nve_initial_password" {}

variable "location" {
  default = ""
}
variable "public_ip" {
  type    = string
  default = "false"
}
variable "nve_tcp_outbound_rules" {
  default = ["443"]
}
variable "nve_resource_group_name" {
  type = string
}
variable "nve_udp_outbound_rules" {
  default = [""]
}

variable "nve_tcp_inbound_rules_Inet" {
  default = ["7543"]
}
variable "nve_tcp_inbound_rules_Vnet" {
  default = ["9000-9001", "8080", "22", "9090", "443", "7937-7954"]
}

variable "resource_group_name" {
  default = ""
}

variable "security_group_id" {
  default = ""
}

variable "nve_version" {
  default = ""
}
variable "nve_type" {
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

variable "nve_hostname" {
  default = "nve"
}
