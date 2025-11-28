variable "cidr_block" {
    description = "cidr block for HTTPS"    
    type = string
    default = "0.0.0.0/0"
  
}
variable "protocol" {
    description = "protocol for HTTPS"
    type = string
    default = "tcp"
  
}   
variable "from_port" {
    description = "from port for HTTPS"
    type = list(string)
    default = [443, 80, 0]
  
}
variable "to_port" {
    description = "to port for HTTPS"
    type = list(string)
    default = [443, 80, 0]
  
}
variable "alb_sg" { 
    description = "ALB security group"
    type = string   
    default = "alb_sg"
  
}
variable "ecs_sg" {
    description = "ECS security group"
    type = string   
    default = "ecs_sg"
  
}
variable "vpc_id" {
    description = "VPC ID"
    type = string   
    default = "vpc_id"
  
}