resource "google_compute_vpn_gateway" "target_gateway" {
  name    = "${var.ENV_NAME}-vpn1"
  network = var.network_name
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
  peer_ip                 = var.peer_ip
  shared_secret           = var.ike_shared_secret
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

resource "google_compute_route" "route" {
  count               = length(var.vpn_route_dest)
  name                = "${var.ENV_NAME}-route-${count.index + 1}"
  network             = var.network_name
  dest_range          = var.vpn_route_dest[count.index]
  priority            = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}


