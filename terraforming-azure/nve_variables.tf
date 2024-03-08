
variable "nve_count" {
  type    = number
  default = 0
  description = "will deploy NVE when number greater 0. Number indicates number of NVE Instances"
}

variable "nve_tcp_inbound_rules_Inet" {
  type    = list(string)
  default = ["22", "443"]
  description = "inbound Traffic rule for Security Group from Internet"
}

variable "nve_initial_password" {
  description = "The initial Password fot the NVE"
  default = "Change_Me12345_"
}

variable "nve_resource_group_name" {
  description = "Bring your own resourcegroup. the Code will read the Data from the resourcegroup name specified here"
  type = string
  default = null
}
variable "nve_public_ip" {
  type    = string
  default = "false"
}
variable "nve_version" {
  type        = string
  default     = "19.10.0"
  description = "NVE Version, can be: '19.8.0', '19.9.2', '19.10.0'"
  validation {
    condition = anytrue([
      var.nve_version == "19.8.0",
      var.nve_version == "19.9.2",
      var.nve_version == "19.10.0",
    ])
    error_message = "Must be a valid NVE Version, can be: '19.8.0', '19.9.2', '19.10.0'."
  }
}


variable "nve_type" {
  type        = string
  default     = "SMALL"
  description = "NVE Type, can be: 'SMALL', 'MEDIUM', 'HIGH', , see Networker Virtual Edition Deployment Guide for more"
  validation {
    condition = anytrue([
      var.nve_type == "SMALL",
      var.nve_type == "MEDIUM",
      var.nve_type == "HIGH",
    ])
    error_message = "Must be a valid NVE Type, can be: 'SMALL', 'MEDIUM', 'HIGH', Networker Virtual Edition Deployment Guide for more."
  }
}
