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


variable "eks_cluster_name" {
  default = "terraform-eks"
  type    = string
}
variable "eks_instance" {}