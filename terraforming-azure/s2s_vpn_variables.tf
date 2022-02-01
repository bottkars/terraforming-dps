variable "create_s2s_vpn" {
  default = false
}

variable "vpn_destination_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "the cidr blocks as string !!! for the destination route in you local network, when s2s_vpn is deployed"

}

variable "tunnel1_preshared_key" {}
variable "wan_ip" {}