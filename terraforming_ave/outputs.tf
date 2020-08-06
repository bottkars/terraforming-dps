output "ave_ssh_public_key" {
  sensitive = true
  value     = "${module.ave.ave_ssh_public_key}"
}

output "ave_ssh_private_key" {
  sensitive = true
  value     = "${module.ave.ave_ssh_private_key}"
}