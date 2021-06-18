output "kubernetes_cluster_name" {
  value       = var.create_gke ? module.gke[0].gke_cluster_name : ""
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = var.create_gke ? module.gke[0].gke_cluster_host : ""
  description = "GKE Cluster Host"
}

output "region" {
  value       = var.create_gke ? module.gke[0].gke_region : ""
  description = "GKE Cluster Region"
}
output "zone" {
  value       = var.create_gke ? var.gcp_zone : ""
  description = "GKE Cluster Region"
}

