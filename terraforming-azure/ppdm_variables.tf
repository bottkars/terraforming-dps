variable "ppdm_count" {
  type    = number
  default = 0
  description = "will deploy PPDM when number greater 0. Number indicates number of PPDM Instances"
}


variable "ppdm_version" {
  type        = string
  default     = "19.9.0"
  description = "PPDM Version, can be: '19.9.0', '19.8.0', '19.6.0'"
  validation {
    condition = anytrue([
      var.ppdm_version == "19.9.0",
      var.ppdm_version == "19.10.0",
    ])
    error_message = "Must be a valid PPDM Version, can be: '19.9.0', '19.8.0'."
  }
}

variable "ppdm_initial_password" {
  default = "Change_Me12345_"
  description = "for use only if ansible playbooks shall hide password"
}

variable "ppdm_public_ip" {
  type    = bool
  default = false
    description = "must we assign a public ip to ppdm"

}
