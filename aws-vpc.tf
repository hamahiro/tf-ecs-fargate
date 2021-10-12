## aws-vpc.tf
# vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${terraform.workspace}"
  }
}

# public subnet
resource "aws_subnet" "public-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.vpc.az_c
  cidr_block              = var.vpc.pub_c_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "vpc-public-1c-${terraform.workspace}"
  }
}
resource "aws_subnet" "public-1d" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.vpc.az_d
  cidr_block              = var.vpc.pub_d_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "vpc-public-1d-${terraform.workspace}"
  }
}

# private subnet
resource "aws_subnet" "private-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.vpc.az_c
  cidr_block              = var.vpc.pri_c_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "vpc-private-1c-${terraform.workspace}"
  }
}
resource "aws_subnet" "private-1d" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.vpc.az_d
  cidr_block              = var.vpc.pri_d_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "vpc-private-1d-${terraform.workspace}"
  }
}

# db subnet 
resource "aws_subnet" "db-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.vpc.az_c
  cidr_block              = var.vpc.db_c_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "vpc-db-1c-${terraform.workspace}"
  }
}
resource "aws_subnet" "db-1d" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.vpc.az_d
  cidr_block              = var.vpc.db_d_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "vpc-db-1d-${terraform.workspace}"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-vpc-${terraform.workspace}"
  }
}

# eip for nat gateway
resource "aws_eip" "eip-ngw-1" {
  vpc = true

  tags = {
    Name = "eip-ngw-1-${terraform.workspace}"
  }
}
# nat gateway
resource "aws_nat_gateway" "ngw-1c" {
  allocation_id = aws_eip.eip-ngw-1.id
  subnet_id     = aws_subnet.public-1c.id

  tags = {
    Name = "ngw-1c-${terraform.workspace}"
  }
}

# route table
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rtb-public-${terraform.workspace}"
  }
}

resource "aws_route_table" "rtb-private-1c" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw-1c.id
  }
  tags = {
    Name = "rtb-private-1c-${terraform.workspace}"
  }
}

# route table association
resource "aws_route_table_association" "assoc_public-1c" {
  subnet_id      = aws_subnet.public-1c.id
  route_table_id = aws_route_table.rtb-public.id
}
resource "aws_route_table_association" "assoc_public-1d" {
  subnet_id      = aws_subnet.public-1d.id
  route_table_id = aws_route_table.rtb-public.id
}
resource "aws_route_table_association" "assoc_private-1c" {
  subnet_id      = aws_subnet.private-1c.id
  route_table_id = aws_route_table.rtb-private-1c.id
}
resource "aws_route_table_association" "assoc_private-1d" {
  subnet_id      = aws_subnet.private-1d.id
  route_table_id = aws_route_table.rtb-private-1c.id
}
