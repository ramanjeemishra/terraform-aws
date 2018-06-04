variable "region" {
  description = "AWS region. Changing it will lead to loss of complete stack."
}

variable "azs" {
  type = "list"
}

variable "environment" {
  default = "poc"
}

variable "name" {
  default = "SC-Test"
}

variable "ami_id_for_webapp" {
  default = "ami-2d39803a"
}

variable "tags" {
  type = "map"
}
