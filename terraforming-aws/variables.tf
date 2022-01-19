variable "create_ddve" { default = false }
variable "create_ave" { default = false }
variable "create_networks" { default = false }
variable "create_s2s_vpn" { default = false }
variable "default_sg_id" { default = null }
#
variable "environment" {
  description = "will be added to many Resource Names / Tags, should be in lower case, abc123 and -"
  validation {
    condition = can (regex("^([a-z0-9-]{3,7})$", var.environment))
    error_message = "Variable environment must be 3 to 7 chars a-z, 0-9, - ."
  }
}
variable "region" {
  type = string
  description = "the region for deployment"
}
variable "vpc_cidr" {
  description = "cidr of the vpc when creating the vpc"
  default = null
}
variable "public_subnets_cidr" {
  type        = list(string)
  description = "cidr of the public subnets cidrs when creating the vpc"
}
variable "private_subnets_cidr" {
  type        = list(string)
  description = "cidr of the private subnets cidrs when creating the vpc"
}
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
  sensitive = true
}
variable "DDVE_HOSTNAME" {
  default = "ddve_terraform"
}
variable "subnet_id" {
  default     = ""
  description = "the subnet to deploy the machines in if vpc is not deployed automatically"
}

variable "ingress_cidr_blocks" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "vpn_destination_cidr_blocks" {
  type        = string
  default     = "[]"
  description = "the cidr blocks as string !!! for the destination route in you local network, when s2s_vpn is deployed"

}
variable "availability_zone" {
  type        = string
  description = "availability_zone to use"
  default     = "eu-central-1a"
}