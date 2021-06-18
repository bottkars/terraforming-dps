resource "google_compute_network" "dps_virtual_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dpc_core_subnet" {
  name          = var.subnetwork_name
  project       = var.gcp_project 
  ip_cidr_range = var.subnet_cidr_block
  region        = var.subnet_region
  network       = google_compute_network.dps_virtual_network.id

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "${var.subnet_secondary_cidr_block_0}"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "${var.subnet_secondary_cidr_block_1}"
  }
}
