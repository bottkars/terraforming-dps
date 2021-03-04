output "ddve_ssh_public_key" {
  sensitive = true
  value     = module.ddve.ddve_ssh_public_key
}

output "ddve_ssh_private_key" {
  sensitive = true
  value     = module.ddve.ddve_ssh_private_key
}


output "ddve_ppdd_nfs_path" {
  sensitive = true
  value     = module.ddve.ddve_ppdd_nfs_path
}
