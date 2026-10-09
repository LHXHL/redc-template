variable "instance_name" {
  type        = string
  description = "Instance name (leave empty to use default)"
  default     = "fileserver"
}

variable "image_id" {
  type        = string
  description = "CVM system image ID"
  default     = "img-pi0ii46r"
}

variable "tencentcloud_secret_id" {
  type        = string
  description = "Set TencentCloud secret id."
  sensitive   = true
  nullable    = false
}

variable "tencentcloud_secret_key" {
  type        = string
  description = "Set TencentCloud secret key."
  sensitive   = true
  nullable    = false
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
