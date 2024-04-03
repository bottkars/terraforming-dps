variable "ppdm_version" {
  type        = string
  default     = "19.16"
  description = "PPDM Version, can be:  '19.16', '19.15'"
  validation {
    condition = anytrue([
      var.ppdm_version == "19.15",
      var.ppdm_version == "19.16",
    ])
    error_message = "Must be a valid PPDM Version, can be: '19.16', '19.15' ."
  }
}
variable "ppdm_count" {
  type        = number
  default     = 0
  description = "Do you want to create a PPDM"
}
variable "PPDM_HOSTNAME" {
  default     = "ppdm-tf"
  description = "Hotname Prefix (adds counting number) of the PPDM Machine"
}
variable "ppdm_source_tags" {
  type        = list(any)
  default     = []
  description = "Source tags applied to Instance for Firewall Rules"
}
variable "ppdm_target_tags" {
  type        = list(any)
  default     = []
  description = "Target tags applied to Instance for Firewall Rules"

}
