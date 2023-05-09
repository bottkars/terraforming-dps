variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
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

  ]
}
variable "nve_type" {}
variable "nve_instance" {}
variable "nve_name" {
  type    = string
  default = "nve_terraform"
}
variable "vpc_id" {}
variable "availability_zone" {}
variable "environment" {}
variable "subnet_id" {}
variable "default_sg_id" {}
variable "ingress_cidr_blocks" {
  type = list
  default = [""]
}
variable "public_subnets_cidr" {
  type        = list(any)
  description = "cidr of the public subnets cidrs when creating the vpc"
}
