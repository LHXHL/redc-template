variable "instance_name" {
  type        = string
  description = "Instance name (leave empty to use default)"
  default     = "sliver"
}

variable "image_id" {
  type        = string
  description = "ECS system image ID"
  default     = "debian_11_7_x64_20G_alibase_20230907.vhd"
}

variable "github_proxy" {
  type        = string
  description = "GitHub Proxy"
}

variable "instance_password" {
  type        = string
  description = "Instance login password (leave empty to auto-generate)"
  sensitive   = true
  default     = ""
}
