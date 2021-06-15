
variable "ENV_NAME" {
  default = ""
}

variable "ddve_meta_disks" {
    default =  ["1000","250","250"]
}

variable instance_name {}
variable instance_zone {}
variable instance_network_name {}
variable instance_subnetwork_name {}