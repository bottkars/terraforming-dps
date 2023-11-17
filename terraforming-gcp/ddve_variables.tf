variable "ddve_count" {
  default     = 0
  type        = number
  description = "Do you want to create a DDVE"
}

variable "DDVE_HOSTNAME" {
  default     = "ddve-tf"
  description = "Hotname of the DDVE Machine"
}


variable "ddve_version" {
  type        = string
  default     = "7.12.0.0"
  description = "DDVE Version, can be: '7.12.0.0', '7.11.0.0','7.10.0.0', '7.8.0.20', '7.7.4.0', '7.9.0.0'"
  validation {
    condition = anytrue([
      var.ddve_version == "7.12.0.0",
      var.ddve_version == "7.9.0.0",
      var.ddve_version == "7.11.0.0",
      var.ddve_version == "7.10.0.0",
      var.ddve_version == "7.8.0.20",
      var.ddve_version == "7.7.4.0",
    ])
    error_message = "Must be a valid DDVE Version, can be: '7.12.0.0','7.11.0.0','7.10.0.0', '7.8.0.20', '7.7.4.0', '7.9.0.0' ."
  }
}

variable "ddve_type" {
  type        = string
  default     = "16 TB DDVE"
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

variable "ddve_source_tags" {
  type        = list(any)
  default     = []
  description = "Source tags applied to Instance for Firewall Rules"

}
variable "ddve_target_tags" {
  type        = list(any)
  default     = []
  description = "Target tags applied to Instance for Firewall Rules"

}
variable "ddve_sa_account_id" {
  description = "The ID of the Service Account for DDVE IAM Policy to Access Storage Bucket via OAuth"

  default = ""
}


variable "ddve_disk_type" {
  type        = string
  default     = "Cost Optimized"
  description = "DDVE Disk Type, can be: 'Performance Optimized', 'Cost Optimized'"
  validation {
    condition = anytrue([
      var.ddve_disk_type == "Performance Optimized",
      var.ddve_disk_type == "Cost Optimized"
    ])
    error_message = "Must be a valid DDVE Disk Type, can be: 'Performance Optimized', 'Cost Optimized'."
  }
}
