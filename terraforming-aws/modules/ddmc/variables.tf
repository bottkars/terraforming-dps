variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
}
variable "environment" {}
variable "vpc_id" {}
variable "region" {}

variable "availability_zone" {}
variable "ingress_cidr_blocks" {
  type    = list(any)
  default = [""]
}
variable "subnet_id" {}
variable "public_subnets_cidr" {
  type        = list(any)
  description = "cidr of the public subnets cidrs when creating the vpc"
}
variable "private_subnets_cidr" {
  type        = list(any)
  description = "cidr of the private subnets cidrs when creating the vpc"
}
variable "default_sg_id" {}


variable "ddmc_type" {}
variable "ddmc_name" {
  type    = string
  default = "ddmc_terraform"
}

variable "ddmc_instance" {
  type = number
}
variable "ddmc_version" {
  default = "7.10.0.0"
}
variable "is_crs" {
  type = bool
  default = false
}
variable "ec2_device_names" {
  default = [
    "/dev/sdc",
    "/dev/sdd",
    "/dev/sde",
    "/dev/sdf",
    "/dev/sdg",
    "/dev/sdh",
    "/dev/sdi",
    "/dev/sdj",
    "/dev/sdk",
    "/dev/sdl",
    "/dev/sdm",
    "/dev/sdn",
    "/dev/sdo",
    "/dev/sdp",
    "/dev/sdq",
    "/dev/sdr",
    "/dev/sds",
    "/dev/sdt",
    "/dev/sdu",
    "/dev/sdv",
    "/dev/sdw",
    "/dev/sdx",
    "/dev/sdy",
    "/dev/sdz",
  ]
}