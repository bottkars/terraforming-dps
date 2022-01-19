output "tunnel1_address" {
  value = module.s2s_vpn[0].tunnel1_address
      description = "The address for the VPN tunnel to configure your local device"

}
