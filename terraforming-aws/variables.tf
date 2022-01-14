variable "create_ddve" { default = true }
variable "create_ave" { default = true }
variable "AVE_HOSTNAME" {
  default = "ave_terraform"
}
variable "DDVE_HOSTNAME" {
  default = "ddve_terraform"
}
variable "SUBNET_ID" {
  default =  "subnet-7120171a"
} 

variable "AVAILABILITY_ZONE" {
    type = string
    description = "availability_zone to use"
    default = "eu-central-1a"
}