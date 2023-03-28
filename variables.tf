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

variable ami_id {
  description = "The AMI ID to use for the instance"
  type        = string
  default = "ami-09b44b5f46219ee9c"
}

variable instance_type {
  description = "The instance type to use for the instance"
  type        = string
  default = "t2.micro"
}

variable instance_count {
  description = "The number of instances to create"
  type        = number
  default = 1
}