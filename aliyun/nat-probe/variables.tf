variable "region" {
  type        = string
  description = "阿里云区域"
  default     = "cn-beijing"
}

variable "instance_name" {
  type        = string
  description = "ECS 实例名称"
  default     = "nat-probe"
}

variable "image_id" {
  type        = string
  description = "ECS 系统镜像 ID"
  default     = "debian_12_2_x64_20G_alibase_20231012.vhd"
}

variable "instance_password" {
  type        = string
  description = "ECS 登录密码 (留空自动生成)"
  sensitive   = true
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "ECS 实例规格"
  default     = "ecs.e-c1m2.large"
}

variable "eip_count" {
  type        = number
  description = "要绑定的弹性公网 IP 数量"
  default     = 5
}

variable "eip_bandwidth" {
  type        = number
  description = "每个 EIP 的带宽 (Mbps)"
  default     = 100
}

variable "eip_isp" {
  type        = string
  description = "EIP 线路类型 (BGP / BGP_PRO)"
  default     = "BGP"
}
