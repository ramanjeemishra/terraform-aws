variable "allow_ssh_access" {
  description = "List of CIDR blocks that can access instances via SSH"
  default     = ["0.0.0.0/0"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "database_subnets" {
  type = "list"
}
