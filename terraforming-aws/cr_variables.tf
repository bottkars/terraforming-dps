variable "create_vault" {
  default     = false
  description = "Do you want to create a Cyber Vault"
}
variable "create_crs_s2s_vpn" {
  default     = false
  description = "Do you want to create a Cyber Vault"
}
variable "crs_wan_ip" {
  description = "The IP of your VPN Device if S2S VPN"
}
variable "crs_private_route_table" {
  default     = ""
  description = "Private Routing table for S2S VPN"
}
variable "crs_vpc_id" {
  default     = ""
  description = "id of the vpc when using existing networks/vpc"

}

variable "crs_vpn_destination_cidr_blocks" {
  type        = string
  default     = "[]"
  description = "the cidr blocks as string !!! for the destination route in you local network, when s2s_vpn is deployed"

}

variable "crs_tunnel1_preshared_key" {
  default     = ""
  sensitive   = true
  description = "the preshared key for teh vpn tunnel when deploying S2S VPN"

}

variable "crs_open_sesame" {
  default     = false
  description = "open 2051 to vault for creating replication context"

}