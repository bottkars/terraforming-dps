variable "vpc_id" {}
variable "wan_ip" {}
variable "environment" {}
variable "vpn_destination_cidr_blocks" {
  type = string
}
variable "private_route_table" {}
variable "tunnel1_preshared_key" {}

variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
}
