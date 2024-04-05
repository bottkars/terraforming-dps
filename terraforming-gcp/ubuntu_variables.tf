variable "ubuntu_count" {
  default     = 0
  type        = number
  description = "Do you want to create a ubuntu"
}
variable "ubuntu_HOSTNAME" {
  default     = "ubuntu-tf"
  description = "Hotname Prefix (adds counting number) of the ubuntu Machine"
}

variable "ubuntu_source_tags" {
  type        = list(any)
  default     = []
  description = "Source tags applied to Instance for Firewall Rules"

}
variable "ubuntu_target_tags" {
  type        = list(any)
  default     = []
  description = "Target tags applied to Instance for Firewall Rules"

}
variable "ubuntu_deletion_protection" {
  type        = bool
  default     = false
  description = "Protect ubuntu from deletion"

}

