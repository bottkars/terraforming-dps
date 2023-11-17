# GKE cluster
data "google_compute_subnetwork" "subnet" {
  name    = var.subnetwork_name
  project = var.gcp_project
  region  = var.region
}
resource "google_container_cluster" "primary" {
  provider = google #-beta
  name     = "${var.gcp_project}-gke"
  location = var.location
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  network    = var.network_name
  subnetwork = var.subnetwork_name
  master_authorized_networks_config {
    // per GKE, if not configured, access to public endpopint allowed generally
    cidr_blocks {
      cidr_block   = "10.204.115.0/24"
      display_name = "private"
    }
    cidr_blocks {
      cidr_block   = "10.204.108.0/24"
      display_name = "private1"
    }
  }
  ip_allocation_policy {
    //  cluster_secondary_range_name  = data.google_compute_subnetwork.subnet.secondary_ip_range.0.range_name // this forced re-deploy !!!
    cluster_ipv4_cidr_block = var.subnet_secondary_cidr_block_0 // must not exist
    //  services_secondary_range_name = data.google_compute_subnetwork.subnet.secondary_ip_range.1.range_name // this forced re-deploy !!!
    services_ipv4_cidr_block = var.subnet_secondary_cidr_block_1 //must not exist
  }
  networking_mode = "VPC_NATIVE"
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block


  }
  lifecycle {
    # ignore changes to node_pool specifically so it doesn't
    #   try to recreate default node pool with every change
    # ignore changes to network and subnetwork so it doesn't
    #   clutter up diff with dumb changes like:
    #   projects/[name]/regions/us-central1/subnetworks/[name]" => "name"
    ignore_changes = [
      node_pool,
      network,
      subnetwork,
    ]
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  provider   = google #-beta
  name       = "${substr(google_container_cluster.primary.name, 0, 28)}-node-pool"
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


