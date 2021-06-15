resource "google_compute_network" "dps_virtual_network" {
  name                    = "${var.ENV_NAME}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dpc_core_subnet" {
  name          = var.subnetwork_name
  project       = var.gcp_project 
  ip_cidr_range = var.subnet_cidr_block
  region        = var.subnet_region
  network       = google_compute_network.dps_virtual_network.id
  }