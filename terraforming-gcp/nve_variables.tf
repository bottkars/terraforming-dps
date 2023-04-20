variable "nve_version" {
  type        = string
  default     = "19.13"
  description = "NVE Version, can be: '19.8'"
  validation {
    condition = anytrue([
      var.nve_version == "19.8",
    ])
    error_message = "Must be a valid NVE Version, can be: '19.8' ."
  }
}
variable "nve_count" {
  default     = false
  description = "Do you want to create a NVE"
}
variable "NVE_HOSTNAME" {
  default     = "nve-tf"
  description = "Hotname Prefix (adds counting number) of the NVE Machine"
}
variable "nve_type" {
  type        = string
  default     = "small"
  description = "NVE Type, can be: 'small', 'medium', 'large'"
  validation {
    condition = anytrue([
      var.nve_type == "small",
      var.nve_type == "medium",
      var.nve_type == "large",

    ])
    error_message = "Must be a valid NVE Type, can be: 'small', 'medium', 'large' ."
  }
}