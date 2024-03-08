
variable "ave_count" {
  type        = number
  default     = 0
  description = "will deploy AVE when number greater 0. Number indicates number of AVE Instances"
}

variable "ave_tcp_inbound_rules_Inet" {
  type        = list(string)
  default     = ["22", "443"]
  description = "inbound Traffic rule for Security Group from Internet"
}

variable "ave_initial_password" {
  default = "Change_Me12345_"
}

variable "ave_resource_group_name" {
  description = "Bring your own resourcegroup. the Code will read the Data from the resourcegroup name specified here"
  type = string
  default = null
}
variable "ave_public_ip" {
  type    = string
  default = "false"
}
variable "ave_version" {
  type        = string
  default     = "19.8.0"
  description = "AVE Version, can be: '19.8.0', '19.7.0', '19.4.02', '19.3.03', '19.2.04'"
  validation {
    condition = anytrue([
      var.ave_version == "19.8.0",
      var.ave_version == "19.7.0",
      var.ave_version == "19.4.02",
      var.ave_version == "19.3.03",
      var.ave_version == "19.2.04",
    ])
    error_message = "Must be a valid AVE Version, can be: '19.8.0', '19.7.0', '19.4.02', '19.3.03', '19.2.04'."
  }
}


variable "ave_type" {
  type        = string
  default     = "0.5 TB AVE"
  description = "AVE Type, can be: '0.5 TB AVE', '1 TB AVE', '2 TB AVE', '4 TB AVE','8 TB AVE','16 TB AVE'"
  validation {
    condition = anytrue([
      var.ave_type == "0.5 TB AVE",
      var.ave_type == "1 TB AVE",
      var.ave_type == "2 TB AVE",
      var.ave_type == "4 TB AVE",
      var.ave_type == "8 TB AVE",
      var.ave_type == "16 TB AVE",

    ])
    error_message = "Must be a valid AVE Type, can be: '0.5 TB AVE', '1 TB AVE', '2 TB AVE', '4 TB AVE','8 TB AVE','16 TB AVE''."
  }
}
