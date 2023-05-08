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
variable "default_sg_id" {}


variable "ddve_type" {}
variable "ddve_name" {
  type    = string
  default = "ddve_terraform"
}

variable "ddve_instance" {
  type = number
}
variable "ddve_version" {
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