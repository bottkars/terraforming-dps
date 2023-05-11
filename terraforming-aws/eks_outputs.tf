output "kubernetes_cluster_name" {
  value       = var.eks_count > 0 ? module.eks[0].eks_cluster_name : null
  description = "EKS Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = var.eks_count > 0 ? module.eks[0].eks_cluster_endpoint : null
  description = "EKS Cluster Host"
}



