variable "environment" {}
variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
}
variable "subnet_id" {}
variable "vpc_id" {}
variable "target_vpc_cidr_block" {}