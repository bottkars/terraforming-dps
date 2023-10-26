resource "google_compute_firewall" "ubuntu-ingress" {
  name          = "${local.ubuntu_name}-ingress"
  network       = var.instance_network_name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "8080", "443", "9000-9001", "9090", "7543", "7937-7954"]
  }
  target_tags = [local.ubuntu_name]
  depends_on = [google_compute_instance.ubuntu]
}
resource "google_compute_firewall" "ubuntu-egress" {
  name          = "${local.ubuntu_name}-egress"
  network       = var.instance_network_name
  source_ranges = ["0.0.0.0/0"]
  direction     = "EGRESS"

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
target_tags = [local.ubuntu_name]
  depends_on  = [google_compute_instance.ubuntu]
}
