resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block 
    instance_tenancy = "default"
    tags = {
        Name = "threatcomp-vpc"

}
}
resource "aws_subnet" "subnet2a" {
    vpc_id            = var.vpc_id
    cidr_block        = "var.public_subnet_cidr_2a"
    availability_zone = var.subnet2a   
    map_public_ip_on_launch = var.public_ip
    tags = {
        Name = "threatcomp-subnet-2a"
    }
  
}

resource "aws_subnet" "subnet2b" {
    vpc_id            = var.vpc_id
    cidr_block        = "var.public_subnet_cidr_2b"
    availability_zone = var.subnet2b   
    map_public_ip_on_launch = var.public_ip
    tags = {
        Name = "threatcomp-subnet-2b"
    }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id

    tags = {
        Name = "threatcomp-igw"
    }
  
}

resource "aws_route_table" "public" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.gateway_id 
    }

    tags = {
        Name = "threatcomp-public-rt"
    }
}
resource "aws_route_table_association" "public_a" {
    subnet_id      = var.public_subnet_ids[0]
    route_table_id = aws_route_table.public.id  

  
}

resource "aws_route_table_association" "public_b" {
    subnet_id      = var.public_subnet_ids[1]
    route_table_id = aws_route_table.public.id
  
}