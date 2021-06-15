
output "ppdm_private_ip" {
    value = module.ppdm.private_ip
}


output "ppdm_ssh_private_key" {
    value = module.ppdm.ssh_private_key
    sensitive = true
}
output "ppdm_ssh_public_key" {
    value = module.ppdm.ssh_public_key
    sensitive = true
}
