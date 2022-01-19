output "vpc_id" {
  value = module.networks[0].vpc_id
    description = "The VPC id"
}
output "private_route_table" {
 value = "${var.create_networks ? module.networks[0].private_route_table : null }"
    description = "The VPC private route table"
}
output "subnet_ids" {
    value = "${var.create_networks ? module.networks[0].private_subnets_id : null }"
    description = "The VPC subnet id´s"
}