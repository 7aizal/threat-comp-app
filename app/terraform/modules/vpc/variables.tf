variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "region" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_azs" {
  type = list(string)
}

variable "private_subnet_azs" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
  
}

