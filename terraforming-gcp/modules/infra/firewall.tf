resource "google_compute_firewall" "internal" {
  name    = "${var.gcp_project}-internal"
  network = google_compute_network.dps_virtual_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = [
    var.subnet_cidr_block,
    var.subnet_secondary_cidr_block_0,
    var.subnet_secondary_cidr_block_1
  ]
}

