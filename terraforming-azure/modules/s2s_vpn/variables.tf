variable "resource_group_name" {}
variable "wan_ip" {}
variable "location" {}
variable "vpn_destination_cidr_blocks" {
  type = list(string)
}
# variable "private_route_table" {}
variable "tunnel1_preshared_key" {}
variable "vnet" {}
variable "environment" { }
variable "vpn_subnet" {

}

#variable "tags" {
#  description = "Key/value tags to assign to all resources."
#  default     = {}
#  type        = map(string)
#}