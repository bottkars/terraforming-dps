variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
}
variable "ec2_device_names" {
  default = [
    "/dev/sdd",
    "/dev/sde",
    "/dev/sdf"
  ]
}
variable "ddve_instance" {}
variable "region" {}
variable "vpc_id" {}
variable "ddve_name" {
  type    = string
  default = "ddve_terraform"
}
variable "environment" {}
variable "ddve_metadata_volume_count" {
  default = 1
}
variable "availability_zone" {}
variable "ingress_cidr_blocks" {
  type    = list(any)
  default = [""]
}
variable "subnet_id" {}
variable "default_sg_id" {}
