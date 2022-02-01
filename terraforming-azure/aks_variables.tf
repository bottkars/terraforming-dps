variable "aks_count" {
  type        = number
  default     = 0
  description = "will deploy AKS Clusters when number greater 0. Number indicates number of AKS Clusters"
}

variable "aks_private_cluster" {
  default     = false
  description = "Determines weather AKS Cluster is Private, currently not supported"
}
variable "aks_private_dns_zone_id" {
  default     = null
  description = "the Zone ID for AKS, currently not supported"
}
variable "networks_aks_subnet_id" {
  default     = ""
  description = "The AKS Subnet ID if not deployed from Module"
}
