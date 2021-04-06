output "ppdm_ssh_public_key" {
  sensitive = true
  value     = module.ppdm.ppdm_ssh_public_key
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = module.ppdm.ppdm_ssh_private_key
}

output "PPDM_PUBLIC_IP_ADDRESS" {
  sensitive = false
  value     = module.ppdm.public_ip_address
}

output "ppdm_username" {
  value= module.ppdm.username
}
