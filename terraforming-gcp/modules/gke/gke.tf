# GKE cluster
data "google_compute_subnetwork" "subnet" {
  name    = "${var.subnetwork_name}"
  project = "${var.gcp_project}"
  region  = "${var.region}"
}
resource "google_container_cluster" "primary" {
  name     = "${var.gcp_project}-gke"
  location = var.zone
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_name
  subnetwork = var.subnetwork_name
  master_authorized_networks_config {

    cidr_blocks {
      cidr_block   = var.master_authorized_networks_cidr_blocks
      display_name = "private"
      }
  }  
  	ip_allocation_policy {
    cluster_secondary_range_name  = "${data.google_compute_subnetwork.subnet.secondary_ip_range.0.range_name}"
    services_secondary_range_name = "${data.google_compute_subnetwork.subnet.secondary_ip_range.1.range_name}"
    } 

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.0.31.0/28"
  }      
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.gcp_project
    }

    # preemptible  = true
    machine_type = "n1-standard-2"
    tags         = ["gke-node", "${var.gcp_project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}


