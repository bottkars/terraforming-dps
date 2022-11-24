
variable "create_crs_s2s_vpn" {
  default     = false
  description = "Do you want to create a Cyber Vault"
}
variable "crs_wan_ip" {
  description = "The IP of your VPN Device if S2S VPN"
}

variable "crs_network_rg_name" {
  default     = ""
  description = "name of the existing vnet"
}

variable "crs_vnet_name" {
  default     = ""
  description = "name of the existing vnet"
}
variable "crs_vpn_subnet" {
  type    = list(string)
  default = ["10.150.1.0/24"]
}

variable "crs_vpn_destination_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "the cidr blocks as string !!! for the destination route in you local network, when s2s_vpn is deployed"

}

variable "crs_tunnel1_preshared_key" {
  default     = ""
  sensitive   = true
  description = "the preshared key for teh vpn tunnel when deploying S2S VPN"

}

