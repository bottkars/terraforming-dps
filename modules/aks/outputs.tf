/*
output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.aks.public_key_openssh
}

output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.aks.private_key_pem
}
*/
output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}