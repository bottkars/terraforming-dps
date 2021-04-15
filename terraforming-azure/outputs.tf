/*
ppdm block output start here
*/
/*
output "ppdm_ssh_public_key" {
  sensitive = true
  value     = module.ppdm.ssh_public_key
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = module.ppdm.ssh_private_key
}

output "PPDM_PUBLIC_IP_ADDRESS" {
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
output "PPDM_INITIAL_PASSWORD" {
  sensitive = true
  value     = var.PPDM_INITIAL_PASSWORD
}
output "DDVE_INITIAL_PASSWORD" {
  sensitive = true
  value     = var.DDVE_INITIAL_PASSWORD
}
/*
 # ppdm output block ends here
*/
/* ave block start here 

output "AVE_PRIVATE_IP" {
  sensitive = false
  value     = module.ave.ave_private_ip
}

output "AVE_PUBLIC_IP" {
  sensitive = false
  value     = module.ave.ave_public_ip
}

/* ddve block output start here */
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
output "DDVE_PUBLIC_IP_ADDRESS" {
  sensitive = false
  value     = module.ddve.public_ip_address
}

output "DDVE_PUBLIC_FQDN" {
  sensitive = false
  value     = module.ddve.public_fqdn
}


output "PPDM_HOSTNAME" {
  sensitive = false
  value     = var.PPDM_HOSTNAME
}

output "PPDD_PATH" {
  sensitive = false
  value     = module.ddve.ppdd_nfs_path
}
/* ddve block ends here*/




/* NVE outut start here */

output "NVE_PUBLIC_FQDN" {
  sensitive = false
  value     = module.nve.public_fqdn
}



output "NVE_PRIVATE_IP" {
  sensitive = false
  value     = module.nve.private_ip
}


output "nve_ssh_public_key" {
  sensitive = true
  value     = module.nve.ssh_public_key
}

output "nve_ssh_private_key" {
  sensitive = true
  value     = module.nve.ssh_private_key
}

/* NVE outut ends here */


/* general output starts here */

output "RESOURCE_GROUP" {
  sensitive = false
  value     = var.ENV_NAME
}


output "AZURE_SUBSCRIPTION_ID" {
  sensitive = false
  value     = var.subscription_id
}
