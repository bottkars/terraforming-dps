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
variable DDVE_VM_SIZE  {
  type        = string
  description = "The Custom Size of the VM"
  validation {
    condition     = contains(["custom-8-32768", "custom-16-65536", "custom-32-131072"], var.DDVE_VM_SIZE)
    error_message = "Valid values for var: DDVE_VM_SIZE are (custom-8-32768, custom-16-65536, custom-32-131072) !"
  } 
}
variable DDVE_META_DISKS {type = list(string)}
variable vpn_shared_secret {}
variable vpn_wan_ip {}