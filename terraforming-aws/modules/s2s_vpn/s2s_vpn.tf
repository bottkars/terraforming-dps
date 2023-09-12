resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id          = var.vpc_id
  amazon_side_asn = var.amazon_side_asn

  tags = merge(
    var.tags,
    { Name = "${var.environment}-vpngw"
    Environment = var.environment },
  )
}
resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = var.bgp_asn
  ip_address = var.wan_ip
  type       = "ipsec.1"

  tags = merge(
    var.tags,
    { Name = "${var.environment}-cusgw"
    Environment = var.environment },
  )
  lifecycle {
    create_before_destroy = true
#    ignore_changes = [ ip_address ]
  }
}

resource "aws_vpn_connection" "vpn_conn" {
  vpn_gateway_id        = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id   = aws_customer_gateway.customer_gateway.id
  type                  = "ipsec.1"
  static_routes_only    = true
  tunnel1_preshared_key = var.tunnel1_preshared_key
 tags = merge(
    var.tags,
    { Name = "${var.environment}-vpnconn"
    Environment = var.environment },
  )
}
resource "aws_vpn_gateway_route_propagation" "vpn_route_prop" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = var.private_route_table
}

resource "aws_vpn_connection_route" "home" {
  destination_cidr_block = var.vpn_destination_cidr_blocks
  vpn_connection_id      = aws_vpn_connection.vpn_conn.id
}
