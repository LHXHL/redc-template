variable "instance_name" {
  type        = string
  description = "Instance name (leave empty to use default)"
  default     = "yakit-server"
}

variable "image_id" {
  type        = string
  description = "ECS system image ID"
  default     = "debian_11_7_x64_20G_alibase_20230907.vhd"
}

variable "yakit_port" {
  type        = number
  description = "Yakit server listening port"
  default     = 8087
}

variable "instance_password" {
  type        = string
  description = "Instance login password (leave empty to auto-generate)"
  sensitive   = true
  default     = ""
}
