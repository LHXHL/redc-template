variable "node" {
  type        = number
  description = "node count"
}

variable "port" {
  type        = string
  description = "ss server port"
}

variable "password" {
  type        = string
  description = "ss server password"
}

variable "filename" {
  type        = string
  description = "clash file name"
}

variable "buckets_name" {
  type        = string
  description = "OSS/R2 bucket name"
}

variable "buckets_path" {
  type        = string
  description = "OSS/R2 path prefix"
}

variable "ami" {
  type        = string
  description = "AMI ID (default: Debian arm64 ap-east-1)"
  default     = "ami-01c9cc5554738042c"
}
