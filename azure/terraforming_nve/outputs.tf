output "nve_ssh_public_key" {
  sensitive = true
  value     = "${module.nve.nve_ssh_public_key}"
}

output "nve_ssh_private_key" {
  sensitive = true
  value     = "${module.nve.nve_ssh_private_key}"
}