output "linux_ssh_public_key" {
  sensitive = true
  value     = "${module.linux.linux_ssh_public_key}"
}

output "linux_ssh_private_key" {
  sensitive = true
  value     = "${module.linux.linux_ssh_private_key}"
}