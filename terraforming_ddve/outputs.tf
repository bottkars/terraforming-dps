output "ddve_ssh_public_key" {
  sensitive = true
  value     = "${module.ddve.ddve_ssh_public_key}"
}

output "ddve_ssh_private_key" {
  sensitive = true
  value     = "${module.ddve.ddve_ssh_private_key}"
}