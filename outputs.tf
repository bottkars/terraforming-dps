/*
ppdm block output start here
*/
output "ppdm_ssh_public_key" {
  sensitive = true
  value     = module.ppdm.ssh_public_key
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = module.ppdm.ssh_private_key
}

output "ppdm_public_ip_address" {
  sensitive = false
  value     = module.ppdm.public_ip_address
}
output "PPDM_FQDN" {
  sensitive = false
  value     = module.ppdm.public_fqdn
}
output "PPDM_PRIVATE_FQDN" {
  sensitive = false
  value     = module.ppdm.private_fqdn
}
/*
ddve block output start here
*/
output "ddve_ssh_public_key" {
  sensitive = true
  value     = module.ddve.ssh_public_key
}

output "ddve_ssh_private_key" {
  sensitive = true
  value     = module.ddve.ssh_private_key
}

output "DDVE_PRIVATE_FQDN" {
  sensitive = false
  value     = module.ddve.private_fqdn
}

output "RESOURCE_GROUP" {
  sensitive = false
  value     = var.env_name
}
