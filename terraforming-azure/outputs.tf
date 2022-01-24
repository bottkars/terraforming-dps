/*
ppdm block output start here
*/
/*
output "ppdm_ssh_public_key" {
  sensitive = true
  value     = module.ppdm[0].ssh_public_key
}

output "ppdm_ssh_private_key" {
  sensitive = true
  value     = module.ppdm[0].ssh_private_key
}

output "ppdm_public_ip_ADDRESS" {
  sensitive = false
  value     = module.ppdm[0].public_ip_address
}
output "PPDM_FQDN" {
  sensitive = false
  value     = module.ppdm[0].public_fqdn
}

}
output "ppdm_initial_password" {
  sensitive = true
  value     = var.ppdm_initial_password
}
output "ddve_initial_password" {
  sensitive = true
  value     = var.ddve_initial_password
}
/*
 # ppdm output block ends here
*/

/* ddve block output start here 
output "ddve_ssh_public_key" {
  sensitive = true
  value     = module.ddve[0].ssh_public_key
}

output "ddve_ssh_private_key" {
  sensitive = true
  value     = module.ddve[0].ssh_private_key
}

output "ddve_private_fqdn" {
  sensitive = false
  value     = module.ddve[0].private_fqdn
}
output "ddve_public_ip_address" {
  sensitive = false
  value     = module.ddve[0].public_ip_address
}

output "ddve_public_fqdn" {
  sensitive = false
  value     = module.ddve[0].public_fqdn
}


output "ppdm_hostname" {
  sensitive = false
  value     = var.ppdm_hostname
}


*/ /* ddve block ends here*/




/* NVE outut start here */

output "NVE_PUBLIC_FQDN" {
  sensitive = false
  value     = var.create_nve ? module.nve[0].public_fqdn : null
}



output "NVE_PRIVATE_IP" {
  sensitive = false
  value     = var.create_nve ? module.nve[0].private_ip : null
}


output "nve_ssh_public_key" {
  sensitive = true
  value     = var.create_nve ? module.nve[0].ssh_public_key : null
}

output "nve_ssh_private_key" {
  sensitive = true
  value     = var.create_nve ? module.nve[0].ssh_private_key : null
}

/* NVE outut ends here 


/* general output starts here */

output "RESOURCE_GROUP" {
  sensitive = false
  value     = var.environment
}


output "AZURE_SUBSCRIPTION_ID" {
  sensitive = false
  value     = var.subscription_id
}

output "DEPLOYMENT_DOMAIN" {
  sensitive = false
  value     = var.create_networks ? module.networks[0].dns_zone_name : null
}

