output "ppdm_ssh_public_key" {
  sensitive = true
  value     = module.ppdm.ppdm_ssh_public_key
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = module.ppdm.ppdm_ssh_private_key
}
