variable "ddve_count" {
  default     = false
  description = "Do you want to create a DDVE"
}

variable "DDVE_HOSTNAME" {
  default     = "ddve-tf"
  description = "Hotname of the DDVE Machine"
}


variable "ddve_version" {
  type        = string
  default     = "7.11.0.0"
  description = "DDVE Version, can be: '7.11.0.0','7.10.0.0', '7.8.0.20', '7.7.4.0', '7.9.0.0'"
  validation {
    condition = anytrue([
      var.ddve_version == "7.9.0.0",
      var.ddve_version == "7.11.0.0",      
      var.ddve_version == "7.10.0.0",
      var.ddve_version == "7.8.0.20",
      var.ddve_version == "7.7.4.0",
    ])
    error_message = "Must be a valid DDVE Version, can be: '7.11.0.0','7.10.0.0', '7.8.0.20', '7.7.4.0', '7.9.0.0' ."
  }
}

variable "ddve_type" {
  type        = string
  default     = "32 TB DDVE"
  description = "DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE'"
  validation {
    condition = anytrue([
      var.ddve_type == "16 TB DDVE",
      var.ddve_type == "32 TB DDVE",
      var.ddve_type == "96 TB DDVE",
      var.ddve_type == "256 TB DDVE"

    ])
    error_message = "Must be a valid DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE'."
  }
}
