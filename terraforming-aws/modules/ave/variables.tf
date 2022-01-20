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
    "/dev/sdf"
  ]
}
variable "ave_instance" {}
variable "ave_name" {
  type    = string
  default = "ave_terraform"
}
variable "vpc_id" {}
variable "ave_data_volume_count" {
  default = 3
}
variable "availability_zone" {}
variable "environment" {}
variable "subnet_id" {}
variable "default_sg_id" {}
variable "ingress_cidr_blocks" {
  type = list
  default = [""]
}
variable "ave_tcp_inbound_rules" {
    default =  [22,161,163,443,7543,700,8543,9090,9443,2700,29000]
}