output "aks_kube_fqdn" {
  value       = var.aks_count > 0 ? module.aks[*].portal_fqdn : null
  description = "all kubeconfigs"
  sensitive   = true
}
output "AKS_KUBE_FQDN" {
  value       = var.aks_count > 0 ? module.aks[0].portal_fqdn : null
  description = "all kubeconfigs"
  sensitive   = true
}

output "aks_kube_name" {
  value       = var.aks_count > 0 ? module.aks[*].name : null
  description = "all kubeconfigs"
  sensitive   = true
}
output "AKS_KUBE_NAME" {
  value       = var.aks_count > 0 ? module.aks[0].name : null
  description = "all kubeconfigs"
  sensitive   = true
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
