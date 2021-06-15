resource "google_compute_firewall" "ddve-ingress" {
  name    = "${var.instance_name}-ingress"
  network = var.instance_network_name

  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["21-23", "80", "111", "139", "389", "443","445","464","2049","2051","2052","3008","3009","5001"]
  }
  allow {
    protocol = "udp"
    ports    = ["111", "123", "137", "161"]
  }
  target_tags = [var.instance_name]

  depends_on = [google_compute_instance.ddve]
}
resource "google_compute_firewall" "ddve-egress" {
  name    = "${var.instance_name}-egress"
  network = var.instance_network_name

  direction = "EGRESS"

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

  target_tags = [var.instance_name]
  depends_on = [google_compute_instance.ddve]


}
