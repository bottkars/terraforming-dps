# ==================== Variables
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
  type    = list
  default = []
}

variable "infrastructure_subnet" {
  default = ""
}


variable "resource_group_name" {
  default = ""
}

variable "ddve_instance" {
  type = number
} 


variable "ddve_password" {
  default = "Change_Me12345_"
}

variable "location" {
  default = ""
}

variable "ddve_meta_disks" {
    default =  ["1000","250","250"]
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
}
variable "public_ip" {
  type    = string
  default = "false"
}



variable "ddve_type" {
  default = "16 TB DDVE"
}

variable "ddve_version" {
  default = "7.7.007"
}

variable "subnet_id" {
  default = ""
}

variable "dns_zone_name" {
  default = ""
}



