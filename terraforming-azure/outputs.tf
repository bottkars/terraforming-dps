

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

