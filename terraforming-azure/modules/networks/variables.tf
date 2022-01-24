variable "environment" {}
variable "networks_instance" {}

variable "location" {}
variable "dns_subdomain" {
    default = ""
}
variable "dns_suffix" {}
variable "virtual_network_address_space" {
  type = list
}
variable "infrastructure_subnet" {}
variable "azure_bastion_subnet" {}
variable "aks_subnet" {}
variable "vpn_subnet" {}
variable "tkg_controlplane_subnet" {}
variable "tkg_workload_subnet" {}
variable "enable_aks_subnet" {
  type = bool
}
variable "enable_tkg_controlplane_subnet" {
  type = bool
}
variable "enable_tkg_workload_subnet" {
  type = bool
}
variable "create_bastion" {
  type = bool
  default = false
}
variable "create_s2s_vpn" {
  type = bool
  default = false
}