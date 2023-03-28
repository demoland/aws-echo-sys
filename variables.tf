variable vpc_id {
  description = "The VPC ID"
  type        = string
}

variable web_port {
  description = "The port the web server is listening on"
  type        = number
  default     = 8080
}

variable key_name {
  description = "The key name to use for the instance"
  type        = string
  default = "management"
}