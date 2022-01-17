variable "create_ddve" { default = false }
variable "create_ave" { default = false }
variable "create_networks" { default = false }
variable "create_s2s_vpn" { default = false }

#
variable "environment" {}
variable "region" {}
variable "vpc_cidr" {}
variable "public_subnets_cidr" {}
variable  "private_subnets_cidr" {}
#
variable "wan_ip" {}
variable "private_route_table" {
  default = ""
}
variable "vpc_id" {
  default = ""
}
variable "AVE_HOSTNAME" {
  default = "ave_terraform"
}
variable "tunnel1_preshared_key" {
  default = ""
}
variable "DDVE_HOSTNAME" {
  default = "ddve_terraform"
}
variable "subnet_id" {
  default =  ""
} 

variable "ingress_cidr_blocks" {
  type = list
  default = ["0.0.0.0/0"]
}
variable "vpn_destination_cidr_blocks" {
  type = string
  default = "[]"
}
variable  "availability_zone"   {
    type = string
    description = "availability_zone to use"
    default = "eu-central-1a"
}