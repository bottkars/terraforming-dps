variable "ENV_NAME" {
}
variable "location" {
}
variable "dns_subdomain" {
    default = ""
}
variable "dns_suffix" {
}
variable "dps_virtual_network_address_space" {
  type = list
}
variable "dps_infrastructure_subnet" {
}
variable "dps_azure_bastion_subnet" {
}
variable "dps_aks_subnet" {
}
variable "dps_tkg_controlplane_subnet" {
}
variable "dps_tkg_workload_subnet" {
}
variable "dps_enable_aks_subnet" {
  type = bool
}
variable "dps_enable_tkg_controlplane_subnet" {
  type = bool
}
variable "dps_enable_tkg_workload_subnet" {
  type = bool
}