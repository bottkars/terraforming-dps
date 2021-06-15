resource "google_compute_firewall" "internal" {
  name    = "${var.ENV_NAME}-internal"
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
    var.subnet_cidr_block
  ]
}

