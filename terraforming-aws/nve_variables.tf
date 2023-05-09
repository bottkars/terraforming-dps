variable "nve_count" {
  type        = number
  default     = 0
  description = "How many nve(s) you want to create ...."
}

variable "NVE_HOSTNAME" {
  default     = "nve_terraform"
  description = "Hostname of the nve Machine"

}

variable "nve_type" {
  type        = string
  default     = "small"
  description = "nve Type, can be 'small','medium','large'"
  validation {
    condition = anytrue([
      var.nve_type == "small",
      var.nve_type == "medium",
      var.nve_type == "large"
    ])
    error_message = "Must be a valid nve Type, can be 'small','medium','large."
  }
}
