variable "ubuntu_count" {
  default     = 0
  type        = number
  description = "Do you want to create a ubuntu"
}
variable "ubuntu_HOSTNAME" {
  default     = "ubuntu-tf"
  description = "Hotname Prefix (adds counting number) of the ubuntu Machine"
}