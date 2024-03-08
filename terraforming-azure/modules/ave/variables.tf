variable "environment" {
  default = ""
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

variable "ave_resource_group_name" {

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
variable "ave_instance" {
  type = number
}
variable "ave_type" {
}

variable "public_ip" {
  type    = bool
  default = "false"
}
variable "location" {
  default = ""
}
variable "ave_initial_password" {}
variable "ave_version" {}

variable "ave_tcp_outbound_rules" {
  default = ["7", "22", "25", "111", "161", "163", "443", "700", "2049", "2052", "3008", "3009", "8443", "8888", "9090", "9443", "2700", "28001-28002", "28810-28819", "29000", "30001-30010"]
}

variable "ave_udp_outbound_rules" {
  default = ["53", "111", "161", "163", "2049", "2052"]
}
variable "ave_tcp_inbound_rules_Inet" {}

variable "ave_tcp_inbound_rules_Vnet" {
  default = ["22", "161", "163", "443", "7543", "700", "7778-7781", "8543", "9090", "9443", "2700", "28001-28002", "28810-28819", "29000", "30001-30010"]
}






