variable "gcp_network" {
  default     = "default"
  type        = string
  description = "GCP Network to be used, change for youn own infra"
}
variable "create_networks" {
  default     = false
  type        = bool
  description = "Do you want to create a VPC"
}
variable "gcp_region" {
  description = "GCP Region to be used"
  type        = string
  default     = "europe-west3"
}
variable "gcp_zone" {
  description = "GCP Zone to be used"
  type        = string
  default     = "europe-west3-c"
}
variable "gcp_subnet_cidr_block_1" {
  description = "Cidr Block of the first Subnet to be used"
  type        = string
  default     = "10.0.16.0/20"
}
variable "gcp_subnetwork_name_1" {
  default     = "default"
  description = "name of the first subnet"
  type        = string
}
variable "gke_master_ipv4_cidr_block" {
  description = "Subnet CIDR BLock for Google Kubernetes Engine Master Nodes"
  type        = string
  default     = "172.16.0.16/28"
}
variable "gke_subnet_secondary_cidr_block_0" {
  description = "Cluster CIDR Block for Google Kubernetes Engine"
  type        = string
  default     = "10.4.0.0/14"
}
variable "gke_subnet_secondary_cidr_block_1" {
  description = "Services CIDR Block for Google Kubernetes Engine"
  type        = string
  default     = "10.0.32.0/20"
}
