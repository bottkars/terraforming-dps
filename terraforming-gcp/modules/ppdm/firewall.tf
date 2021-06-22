resource "google_compute_firewall" "ppdm-ingress" {
  name    = "${var.instance_name}-ingress"
  network = var.instance_network_name

  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "7000", "14443", "7444","8443"]
  }

  target_tags = [var.instance_name]

  depends_on = [google_compute_instance.ppdm]
}
resource "google_compute_firewall" "ppdm-egress" {
  name    = "${var.instance_name}-egress"
  network = var.instance_network_name

  direction = "EGRESS"

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

  target_tags = [var.instance_name]
  depends_on = [google_compute_instance.ppdm]


}
