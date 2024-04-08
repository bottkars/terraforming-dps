variable "ddmc_count" {
  default     = false
  description = "Do you want to create a ddmc"
}

variable "DDMC_HOSTNAME" {
  default     = "ddmc_terraform"
  description = "Hotname of the ddmc Machine"
}


variable "ddmc_version" {
  type        = string
  default     = "7.13.0.10"
  description = "ddmc Version, can be: '7.13.0.10','7.10.1.20', '7.7.5.30'"
  validation {
    condition = anytrue([
      var.ddmc_version == "7.13.0.10",
      var.ddmc_version == "7.10.1.20",
      var.ddmc_version == "7.7.5.30",
    ])
    error_message = "Must be a valid ddmc Version, can be: '7.13.0.10','7.10.1.20', '7.7.5.30' ."
  }
}



variable "ddmc_type" {
  type        = string
  default     = "12.5 Gigabit Ethernet ddmc"
  description = "ddmc Type, can be: '12.5 Gigabit Ethernet ddmc', '10 Gigabit Ethernet ddmc'"
  validation {
    condition = anytrue([
      var.ddmc_type == "12.5 Gigabit Ethernet ddmc",
      var.ddmc_type == "10 Gigabit Ethernet ddmc",
    ])
    error_message = "Must be a valid ddmc Type, can be: '12.5 Gigabit Ethernet ddmc', '10 Gigabit Ethernet ddmc'."
  }
}
