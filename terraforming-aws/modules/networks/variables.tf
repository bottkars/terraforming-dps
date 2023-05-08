variable "is_crs" {
  type = bool
  default = false
}
variable "vpc_name" {}
variable "environment" {}
variable "vpc_cidr" {}
variable "public_subnets_cidr" {}
variable "private_subnets_cidr" {}
variable "availability_zones" {}
variable "networks_instance" {}
variable "region" {}
variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
}