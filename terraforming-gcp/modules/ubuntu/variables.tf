variable "ubuntu_name" {}
variable "instance_zone" {}
variable "instance_network_name" {}
variable "instance_subnetwork_name" {}
variable "ubuntu_instance" {}
variable "labels" { type = map(any) }
variable "environment" {}
variable  "ubuntu_target_tags" {
  type = list
  default = []
}  
variable  "ubuntu_source_tags" {
  type = list
  default = []
}  