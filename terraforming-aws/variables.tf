variable "create_client_vpn"{
  default = false
  description = "Create a pre-conig site2client"
}

variable "create_bastion" {
  default     = false
  description = "Do you want to create an PPDM"
}
variable "create_networks" {
  default     = false
  description = "Do you want to create a VPC"
}
variable "create_crs_networks" {
  default     = false
  description = "Do you want to create a VPC"
}
variable "create_s2s_vpn" {
  default     = false
  description = "Do you want to create a Site 2 Site VPN for default VPN Device ( e.g. UBNT-UDM Pro)"

}
variable "default_sg_id" {
  default     = null
  description = "id of default security group when using existing networks"

}
variable "cr_sg_id" {
  default     = null
  description = "id of default security group when using existing networks"

}

variable "vault_sg_id" {
  default     = null
  description = "id of default security group when using existing networks"

}

variable "tags" {
  description = "Key/value tags to assign to resources."
  default     = {}
  type        = map(string)
}
variable "tags_all" {
  description = "Key/value for TopLevel Tagsntags to assign to all resources."
  default     = {}
  type        = map(string)
}
variable "environment" {
  description = "will be added to many Resource Names / Tags, should be in lower case, abc123 and -"
  validation {
    condition     = can(regex("^([a-z0-9-]{3,7})$", var.environment))
    error_message = "Variable environment must be 3 to 7 chars a-z, 0-9, - ."
  }
}

variable "region" {
  type        = string
  description = "the region for deployment"
}
variable "vpc_cidr" {
  description = "cidr of the vpc when creating the vpc"
  default     = null
}
variable "public_subnets_cidr" {
  type = list(any)
  #  type        = list(string)
  description = "cidr of the public subnets cidrs when creating the vpc. Public Cidr´(s) are most likely used for Bastion´s"
}
variable "private_subnets_cidr" {
  type        = list(any)
  description = "cidr of the private subnets cidrs when creating the vpc"
}
#
variable "wan_ip" {
  description = "The IP of your VPN Device if S2S VPN"
}
variable "private_route_table" {
  default     = ""
  description = "Private Routing table for S2S VPN"
}
variable "vpc_id" {
  default     = ""
  description = "id of the vpc when using existing networks/vpc"

}

variable "tunnel1_preshared_key" {
  default     = ""
  sensitive   = true
  description = "the preshared key for teh vpn tunnel when deploying S2S VPN"

}

variable "BASTION_HOSTNAME" {
  default     = "bastion_terraform"
  description = "Hotname of the PPDM Machine"
}
variable "subnet_id" {
  type        = list(any)
  default     = []
  description = "the subnet to deploy the machines in if vpc is not deployed automatically"
}

variable "ingress_cidr_blocks" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "Machines to allow ingress, other than default SG ingress"

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

variable "aws_profile" {
}


