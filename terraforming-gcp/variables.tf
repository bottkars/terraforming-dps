variable "gcp_project" {}
variable "gcp_credentials" {}
variable "ddve_instance_name" { default = "ddve1" }
variable "ppdm_instance_name" { default = "ppdm1" }
variable "gcp_region" { default = "europe-west3" }
variable "gcp_zone" { default = "europe-west3-c" }
variable "gcp_network" { default = "gtovpcwest3" }
variable "subnet_cidr_block_1" {}
variable "subnetwork_name_1" { default =  "gtosubnet172" }
variable "ENV_NAME" {}