resource "google_compute_vpn_gateway" "target_gateway" {
  name    = "${var.ENV_NAME}-vpn1"
  network = google_compute_network.dps_virtual_network.id
}


resource "google_compute_address" "vpn_static_ip" {
  name = "${var.ENV_NAME}-vpn-static-ip"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name                    = "${var.ENV_NAME}-tunnel1"
  peer_ip                 = "91.62.6.61"
  shared_secret           = "BwNap2HrjvtSxq2LGNXHuA27/dwdOrox"
  target_vpn_gateway      = google_compute_vpn_gateway.target_gateway.id
  local_traffic_selector  = ["0.0.0.0/0"]
  remote_traffic_selector = ["0.0.0.0/0"]
  ike_version             = 2

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

resource "google_compute_route" "route1" {
  name       = "${var.ENV_NAME}-route1"
  network    = google_compute_network.dps_virtual_network.name
  dest_range = "192.168.1.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}

resource "google_compute_route" "route2" {
  name       = "${var.ENV_NAME}-route2"
  network    = google_compute_network.dps_virtual_network.name
  dest_range = "100.250.1.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}
