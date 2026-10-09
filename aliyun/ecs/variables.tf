variable "instance_name" {
  type        = string
  description = "Instance name (leave empty to use default)"
  default     = "aliyun_ecs"
}

variable "image_id" {
  type        = string
  description = "ECS system image ID"
  default     = "debian_12_2_x64_20G_alibase_20231012.vhd"
}

variable "instance_password" {
  type        = string
  description = "Instance login password (leave empty to auto-generate)"
  sensitive   = true
  default     = ""
}
