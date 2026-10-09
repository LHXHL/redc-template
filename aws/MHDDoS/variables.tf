variable "node" {
  type        = number
  description = "node count"
}

variable "ddos_target" {
  type        = string
  description = "ddos target"
}

variable "ddos_threads" {
  type        = string
  description = "ddos threads"
}

variable "ddos_time" {
  type        = string
  description = "ddos time"
}

variable "ddos_mode" {
  type        = string
  description = "APACHE / COOKIE / BYPASS / DOWNLOADER / POST / XMLRPC"
}

variable "ami" {
  type        = string
  description = "AMI ID (default: Debian arm64 ap-east-1)"
  default     = "ami-01c9cc5554738042c"
}
