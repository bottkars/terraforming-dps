variable "gcp_project" {}
variable "gcp_credentials" {}
variable "DDVE_HOSTNAME" { default = "ddve1" }
variable "PPDM_HOSTNAME" { default = "ppdm1" }
variable "gcp_region" { default = "europe-west3" }
variable "gcp_zone" { default = "europe-west3-c" }
variable "gcp_network" {}
variable "subnet_cidr_block_1" {}
variable "subnetwork_name_1" {}
variable "ENV_NAME" {}
variable create_ddve {}
variable create_ppdm {}
variable DDVE_IMAGE {type = map}
variable PPDM_IMAGE {type = map}
variable DDVE_VM_SIZE {}
variable DDVE_META_DISKS {type = list(string)}
variable vpn_shared_secret {}
variable vpn_wan_ip {}