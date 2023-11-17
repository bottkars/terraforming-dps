variable "ppdm_version" {
  type        = string
  default     = "19.14"
  description = "PPDM Version, can be: '19.11', '19.12', '19.13', '19.14'"
  validation {
    condition = anytrue([
      var.ppdm_version == "19.14",
      var.ppdm_version == "19.13",
      var.ppdm_version == "19.12",
      var.ppdm_version == "19.11",

    ])
    error_message = "Must be a valid PPDM Version, can be: '19.11', '19.12', '19.13', '19.14' ."
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
