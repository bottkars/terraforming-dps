resource "google_compute_firewall" "ddve-ingress" {
  name          = "${local.ddve_name}-ingress"
  network       = var.instance_network_name
  source_ranges = ["0.0.0.0/0"]

  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["21-23", "80", "111", "139", "389", "443", "445", "464", "2049", "2051", "2052", "3008", "3009", "5001"]
  }
  allow {
    protocol = "udp"
    ports    = ["111", "123", "137", "161"]
  }
  target_tags = [local.ddve_name]

  depends_on = [google_compute_instance.ddve]

}
resource "google_compute_firewall" "ddve-egress" {
  name          = "${local.ddve_name}-egress"
  network       = var.instance_network_name
  source_ranges = ["0.0.0.0/0"]
  direction     = "EGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["20", "25", "80", "443", "2051", "3009", "5001", "27000", "28001", "28002", "29000"]
  }
  allow {
    protocol = "udp"
    ports    = ["53", "2052"]
  }
  source_tags = var.source_tags
  target_tags = concat(
    var.target_tags,
    [local.ddve_name]
    )
  depends_on  = [google_compute_instance.ddve]

}
