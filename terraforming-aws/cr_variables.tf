variable "create_vault" {
  default     = false
  description = "Do you want to create a Cyber Vault"
}
variable "create_crs_s2s_vpn" {
  default     = false
  description = "Do you want to create a Cyber Vault"
}
variable "create_crs_client_vpn" {
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
variable "vault_nve_count" {
  type    = number
  default = 0
}
variable "crs_subnet_id" {}
variable "crs_vault_subnet_id" {}
variable "vault_ingress_cidr_blocks" {}
variable "crs_environment" {
  default     = "crs"
  description = "will be added to many Resource Names / Tags, should be in lower case, abc123 and -"
  validation {
    condition     = can(regex("^([a-z0-9-]{3,7})$", var.crs_environment))
    error_message = "Variable environment must be 3 to 7 chars a-z, 0-9, - ."
  }
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
variable "crs_vpc_cidr" {}

variable "crs_open_sesame" {
  default     = false
  description = "open 2051 to vault for creating replication context"

}

variable "crs_public_subnets_cidr" {
  type = list(any)
  #  type        = list(string)
  description = "cidr of the public subnets cidrs when creating the vpc"
}
variable "crs_private_subnets_cidr" {
  type        = list(any)
  description = "cidr of the private subnets cidrs when creating the vpc"
}
