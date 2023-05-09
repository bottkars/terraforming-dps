variable "ave_count" {
  type        = number
  default     = 0
  description = "How many AVE(s) you want to create ...."
}

variable "AVE_HOSTNAME" {
  default     = "ave_terraform"
  description = "Hotname of the AVE Machine"

}

variable "ave_type" {
  type        = string
  default     = "0.5 TB AVE"
  description = "AVE Type, can be '0.5 TB AVE','1 TB AVE','2 TB AVE','4 TB AVE','8 TB AVE','16 TB AVE'"
  validation {
    condition = anytrue([
      var.ave_type == "0.5 TB AVE",
      var.ave_type == "1 TB AVE",
      var.ave_type == "2 TB AVE",
      var.ave_type == "4 TB AVE",
      var.ave_type == "8 TB AVE",
      var.ave_type == "16 TB AVE"

    ])
    error_message = "Must be a valid AVE Type, can be '0.5 TB AVE','1 TB AVE','2 TB AVE','4 TB AVE','8 TB AVE','16 TB AVE'."
  }
}
