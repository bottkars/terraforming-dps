variable "gcp_project" {}
variable "gcp_credentials" {}
variable "DDVE_HOSTNAME" { default = "ddve1" }
variable "PPDM_HOSTNAME" { default = "ppdm1" }
variable "gcp_region" { default = "europe-west3" }
variable "gcp_zone" { default = "europe-west3-c" }
variable "gcp_network" { default = "default" }
variable "gcp_subnet_cidr_block_1" { default = "10.0.0.0/20" }
variable "gcp_subnetwork_name_1" { default = "default" }
variable "ENV_NAME" { default = "default" }
variable "create_ddve" { default = true }
variable "create_ppdm" { default = true }
variable "create_infra" { default = false }
variable "create_s2svpn" { default = false }
variable "DDVE_IMAGE" {
  type = map(any)
  default = {
    "publisher" : "dellemc-ddve-public",
    "offer" : "ppdm_0_0_1",
    "sku" : "ddve-gcp",
    "version" : "7-6-0-5-685135"
  }
}
variable "PPDM_IMAGE" {
  type = map(any)
  default = {
    "publisher" : "dellemc-ddve-public",
    "offer" : "ppdm_0_0_1",
    "sku" : "powerprotect",
    "version" : "19-8-0-5"
  }
}
variable "DDVE_VM_SIZE" {
  type        = string
  default     = "custom-8-32768"
  description = "The Custom Size of the VM"
  validation {
    condition     = contains(["custom-8-32768", "custom-16-65536", "custom-32-131072"], var.DDVE_VM_SIZE)
    error_message = "Valid values for var: DDVE_VM_SIZE are (custom-8-32768, custom-16-65536, custom-32-131072) !"
  }
}
variable "DDVE_META_DISKS" {
  type    = list(string)
  default = ["1000", "1000"]
}
variable ubnt_vpn_route_dest {
  type = list(string)
  default = ["127.0.0.1/32"]
}
variable "vpn_shared_secret" { default = "topsecret12345" }
variable "vpn_wan_ip" { default = "0.0.0.0" }
