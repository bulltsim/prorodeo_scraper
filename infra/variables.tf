variable "project" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "db_name" {
  type    = string
  default = "prorodeo"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "s3_bucket" {
  type    = string
}
