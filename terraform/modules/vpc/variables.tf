variable "vpc_cidr_block" {
  description = "CIDR block for vpc"
  type = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_ids" {
    description = "public subnets" 
    type = list(string)

}

variable "region" {
    description = "AWS region"
    type        = string
    default     = "eu-west-2"
  
}
variable "public_ip" {
    type = string
    default = "true"

}

variable "subnet2a" {
    type = string
    default = "eu-west-2a"
  
}

variable "subnet2b" {
    type = string
    default = "eu-west-2b" 
  
}

variable "public_subnet_cidr_2a" {
    description = "Public subnet CIDR for AZ eu-west-2a"
    type = string
    default = "10.0.1.0/24"
  
}

variable "public_subnet_cidr_2b" {
    description = "Public subnet CIDR for AZ eu-west-2b"
    type = string
    default = "10.0.1.0/24"
  
}

variable "vpc_id" {
    type = string   
    default = "aws_vpc.main.id"
  
}

variable "gateway_id" {
    type = string   
    default = "aws_internet_gateway.igw.id"
  
}