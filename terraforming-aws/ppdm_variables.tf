
variable "ppdm_count" {
  default     = 0
  description = "Do you want to create an PPDM"
}


variable "PPDM_HOSTNAME" {
  default     = "ppdm_terraform"
  description = "Hotname of the PPDM Machine"
}


variable "ppdm_version" {
  type        = string
  default     = "19.11"
  description = "VERSION Version, can be: '19.11', '19.10', '19.9', '19.8', '19.7'"
  validation {
    condition = anytrue([
      var.ppdm_version == "19.11",
      var.ppdm_version == "19.10",
      var.ppdm_version == "19.9",
      var.ppdm_version == "19.8",
      var.ppdm_version == "19.7",
    ])
    error_message = "Must be a valid DDVE Version, can be: '19.11', '19.10', '19.9', '19.8', '19.7' ."
  }
}