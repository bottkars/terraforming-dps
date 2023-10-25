resource "google_compute_firewall" "ppdm-ingress" {
  name          = "${local.ppdm_name}-ingress"
  network       = var.instance_network_name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "7000", "14443", "7444", "8443"]
  }
  target_tags = [local.ppdm_name]
  depends_on = [google_compute_instance.ppdm]
}
resource "google_compute_firewall" "ppdm-egress" {
  name          = "${local.ppdm_name}-egress"
  network       = var.instance_network_name
  source_ranges = ["0.0.0.0/0"]
  direction     = "EGRESS"

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["389", "636", "3009", "5989", "7000", "25", "587", "143", "993", "2702", "111", "2049", "2052", "9443", "9090", "9613", "30095", "14251"]
  }
  allow {
    protocol = "udp"
    ports    = ["123", "162", "514"]
  }
  source_tags = var.ppdm_source_tags
  target_tags = concat(
    var.ppdm_target_tags,
    [local.ppdm_name],
    )
  depends_on  = [google_compute_instance.ppdm]
}
