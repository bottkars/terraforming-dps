
output "ddve_private_ip" {
    value = module.ddve.private_ip
}


output "ddve_ssh_private_key" {
    value = module.ddve.ssh_private_key
    sensitive = true
}
output "ddve_ssh_public_key" {
    value = module.ddve.ssh_public_key
    sensitive = true
}
