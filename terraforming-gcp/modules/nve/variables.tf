variable "nve_name" {}
variable "instance_zone" {}
variable "instance_network_name" {}
variable "instance_subnetwork_name" {}
variable "nve_type" {} //don´t change this walue
variable "nve_instance" {}
variable "nve_version" {}
variable "labels" { type = map(any) }
variable "environment" {}
