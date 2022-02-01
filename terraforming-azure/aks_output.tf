output "k8s_fqdn" {
  value       = var.aks_count > 0 ? module.aks[*].portal_fqdn : null
  description = "FQDN´s of the All AKS Clusters"
  sensitive   = true
}
output "K8S_FQDN" {
  value       = var.aks_count > 0 ? module.aks[0].portal_fqdn : null
  description = "the FQDN of the AKS Cluster"
  sensitive   = true
}

output "aks_cluster_name" {
  value       = var.aks_count > 0 ? module.aks[*].name : null
  description = "all Kubernetes Cluster Names"
}
output "K8S_CLUSTER_NAME" {
  value       = var.aks_count > 0 ? module.aks[0].name : null
  description = "The Name of the K8S Cluster"
}

output "aks_kube_config" {
  value       = var.aks_count > 0 ? module.aks[*].kube_config : null
  description = "all kubeconfigs"
  sensitive   = true
}

output "AKS_KUBE_CONFIG" {
  value       = var.aks_count > 0 ? module.aks[0].kube_config : null
  description = "first cluster kubeconfig"
  sensitive   = true
}


output "AKS_KUBE_API" {
  value       = var.aks_count > 0 ? module.aks[0].host : null
  description = "first API Seyrver"
  sensitive   = true
}


output "aks_kube_api" {
  value       = var.aks_count > 0 ? module.aks[*].host : null
  description = "all API Servers"
  sensitive   = true
}
