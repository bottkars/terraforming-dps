/*output "aks_ssh_public_key" {

  sensitive = true
  value     = module.aks.ssh_public_key
}

output "aks_ssh_private_key" {
  sensitive = true
  value     = module.aks.ssh_private_key
}
*/
output "kube_config" {
  value = module.aks.kube_config
}

output "host" {
  value = module.aks.host
}