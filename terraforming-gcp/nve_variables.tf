variable "nve_version" {
  type        = string
  default     = "19.10"
  description = "NVE Version, can be: '19.9','19.10'"
  validation {
    condition = anytrue([
      var.nve_version == "19.10", 
      var.nve_version == "19.9",

    ])
    error_message = "Must be a valid NVE Version, can be: '19.9', '19.10' ."
  }
}
variable "nve_count" {
  default     = 0
  type        = number
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
      var.nve_type == "large"
    ])
    error_message = "Must be a valid NVE Type, can be: 'small', 'medium', 'large' ."
  }
}
variable "nve_source_tags" {
  type        = list(any)
  default     = []
  description = "Source tags applied to Instance for Firewall Rules"

}
variable "nve_target_tags" {
  type        = list(any)
  default     = []
  description = "Target tags applied to Instance for Firewall Rules"

}
