output "kubernetes_cluster_name" {
  value       = var.create_gke ? module.gke[0].gke_cluster_name : ""
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = var.create_gke ? module.gke[0].gke_cluster_host : ""
  description = "GKE Cluster Host"
}


output "location" {
  value       = var.create_gke ? "${var.gke_zonal ? var.gcp_zone : var.gcp_region }" : ""
  description = "GKE Cluster location"
}

