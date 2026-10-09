variable "domain" {
  type        = string
  description = "domain"
}

variable "ami" {
  type        = string
  description = "AMI ID (default: Debian arm64 ap-east-1)"
  default     = "ami-01c9cc5554738042c"
}
