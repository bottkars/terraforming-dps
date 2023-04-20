variable "ppdm_name" {}
variable "instance_zone" {}
variable "instance_network_name" {}
variable "instance_subnetwork_name" {}
variable "instance_size" {} //don´t change this walue
variable "ppdm_instance" {}
variable "ppdm_version" {}
variable "labels" { type = map(any) }
variable "environment" {}
