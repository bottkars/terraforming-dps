output "ppdm_ssh_public_key" {
  sensitive = true
  value     = module.ppdm.ppdm_ssh_public_key
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = module.ppdm.ppdm_ssh_private_key
}

output "ppdm_public_ip_address" {
  sensitive = false
  value     = module.ppdm.public_ip_address
}

output "ppdm_username" {
  value= module.ppdm.username
}
