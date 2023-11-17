resource "google_compute_firewall" "nve-ingress" {
  name          = "${local.nve_name}-ingress"
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
  target_tags = [local.nve_name]
  depends_on  = [google_compute_instance.nve]
}
resource "google_compute_firewall" "nve-egress" {
  name          = "${local.nve_name}-egress"
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
  source_tags = var.source_tags
  target_tags = concat(
    var.target_tags,
    [local.nve_name]
  )
  depends_on = [google_compute_instance.nve]
}
