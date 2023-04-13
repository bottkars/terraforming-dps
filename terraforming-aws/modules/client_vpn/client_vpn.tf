resource "aws_acm_certificate" "server" {
  private_key       = file("~/custom_folder/server.key")
  certificate_body  = file("~/custom_folder/server.crt")
  certificate_chain = file("~/custom_folder/ca.crt")

  tags = merge(
    var.tags,
    { Name = "${var.environment}-vpngw"
    Environment = var.environment },
  )
}



resource "aws_ec2_client_vpn_endpoint" "dev" {

  description                       = "client-vpn-endpoint-01"
  server_certificate_arn            = aws_acm_certificate.server.arn
  client_cidr_block                 = "172.20.0.0/22"
  split_tunnel                      = true
  security_group_ids = [aws_security_group.vpn_access.id]

  # dns_servers = ["75.75.75.75", "76.76.76.76"]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.server.arn
  }

  connection_log_options {
    enabled = false
  }

}

resource "aws_security_group" "vpn_access" {
  vpc_id = var.vpc_id
  name   = "vpn-sg"

  ingress {
    from_port   = 443
    protocol    = "UDP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN connection"
  }
  ingress {
    from_port   = 3389
    protocol    = "TCP"
    to_port     = 3389
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming RDP connection"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.environment}-vpngw"
    Environment = var.environment },
  )

}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.dev.id
  subnet_id              = var.subnet_id
  //  security_groups        = [aws_security_group.vpn_access.id]
}

resource "aws_ec2_client_vpn_authorization_rule" "example" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.dev.id
  target_network_cidr    = var.target_vpc_cidr_block
  authorize_all_groups   = true
}

