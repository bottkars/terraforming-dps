output "vpc_id" {
  value = module.networks[0].vpc_id
}
output "private_route_table" {
 value = "${var.create_networks ? module.networks[0].private_route_table : null }"
}
output "subnet_ids" {
    value = "${var.create_networks ? module.networks[0].private_subnets_id : null }"
}