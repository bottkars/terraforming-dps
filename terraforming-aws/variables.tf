variable "create_ddve" { default = false }
variable "create_ave" { default = false }
variable "create_networks" { default = false }
variable "create_s2s_vpn" { default = false }
variable "default_sg_id" { default = null }
variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
}
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



variable "ave_type" {
  type = string
  default = "0.5 TB AVE"
  validation {
    condition = anytrue([
      var.ave_type == "0.5 TB AVE",
      var.ave_type == "1 TB AVE",
      var.ave_type == "2 TB AVE",
      var.ave_type == "4 TB AVE",
      var.ave_type == "8 TB AVE",
      var.ave_type == "16 TB AVE"

    ])
    error_message = "Must be a valid AVE Type, can be '0.5 TB AVE','1 TB AVE','2 TB AVE','4 TB AVE','8 TB AVE','16 TB AVE'."
  }
}

variable "ddve_type" {
  type = string
  default = "16 TB DDVE"
  validation {
    condition = anytrue([
      var.ddve_type == "16 TB DDVE",
      var.ddve_type == "32 TB DDVE",
      var.ddve_type == "96 TB DDVE",
      var.ddve_type == "256 TB DDVE"

    ])
    error_message = "Must be a valid DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE'."
  }
}
