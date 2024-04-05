
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
  default     = "19.16.0"
  description = "VERSION Version, can be: '19.14.0', '19.15.0', '19.16.0'"
  validation {
    condition = anytrue([
      var.ppdm_version == "19.14.0",
      var.ppdm_version == "19.15.0",
      var.ppdm_version == "19.16.0",      
    ])
    error_message = "Must be a valid DDVE Version, can be: '19.14.0', '19.15.0', '19.16.0' ."
  }
}