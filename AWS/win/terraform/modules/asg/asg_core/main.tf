data "aws_region" "current" {}

data "aws_vpc" "fme_server" {
  id = aws_vpc.fme_server.id
}

data "aws_subnet" "private_subnet_az1" {
  id = aws_route_table_association.private_subnet_az1
}

data "aws_subnet" "private_subnet_az2" {
  id = aws_route_table_association.private_subnet_az2
}

resource "aws_vpc" "fme_server" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"    = var.vnet_name
  }
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = format("%sa", aws_region.current.name)
  tags = {
    "Name"    = format("%s-public1-%sa", var.public_snet_name, aws_region.current.name)
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = format("%sa", aws_region.current.name)
  tags = {
    "Name"    = format("%s-public2-%sa", var.public_snet_name, aws_region.current.name)
  }
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = format("%sa", aws_region.current.name)
  tags = {
    "Name"    = format("%s-private1-%sa", var.public_snet_name, aws_region.current.name)
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = format("%sa", aws_region.current.name)
  tags = {
    "Name"    = format("%s-private2-%sa", var.public_snet_name, aws_region.current.name)
  }
}

resource "aws_internet_gateway" "fme_server" {
  vpc_id = aws_vpc.fme_server.id
  tags = {
    "Name"    = var.igw_name
  }
}

resource "aws_nat_gateway" "fme_server" {
  subnet_id = aws_subnet.public_subnet_az1.id
  tags = {
    "Name"    = var.nat_name
  }
}

resource "aws_default_route_table" "fmeserver_default_rt" {
  default_route_table_id = aws_vpc.fme_server.default_route_table_id

  route = {
    cidr_block = "0.0.0.0/"
    nat_gateway_id = aws_nat_gateway.fme_server.id
  }
  tags = {
    "Name"    = "Private subnets route table"
  } 
}

resource "aws_route_table_association" "private_subnet_az1" {
  subnet_id = aws_subnet.private_subnet_az1.id
  route_table_id = aws_default_route_table.fmeserver_default_rt
}

resource "aws_route_table_association" "private_subnet_az2" {
  subnet_id = aws_subnet.private_subnet_az2.id
  route_table_id = aws_default_route_table.fmeserver_default_rt
}

resource "aws_route_table" "fmeserver_public_rt" {
  vpc_id = aws_vpc.fme_server.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fme_server.id
  } 
    tags = {
    "Name"    = "Public subnets route table"
  } 
}

resource "aws_route_table_association" "public_subnet_az1" {
  subnet_id = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.fmeserver_public_rt
}

resource "aws_route_table_association" "public_subnet_az2" {
  subnet_id = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.fmeserver_public_rt
}

resource "aws_db_subnet_group" "rds_subnet_roup" {
  name_prefix = "fmedbsubnetgroup"
  subnet_ids = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id]
  tags = {
    "Name"    = "RDS subnet group"
  }
}

resource "aws_security_group" "fmeserver" {
  vpc_id      = aws_vpc.fme_server.id
  name        = "FME Server security group"
  description = "Allows communication between FME Server components"

  ingress = [
    {
      description      = "Allow all traffic between EC2, ALB, RDS & FSx in VPC"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      self             = true
    },
    {
      description      = "Web UI from local IP"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = ["50.68.182.79/32"]
    },
    {
      description      = "Web socket from local IP"
      protocol         = "tcp"
      from_port        = 7078
      to_port          = 7078
      cidr_blocks      = ["50.68.182.79/32"]
    },
    {
      description      = "Web UI from NAT gateway"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = []
    },
    {
      description      = "Engine registration health check"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = [data.aws_vpc.fme_server.cidr_block]
    },
    {
      description      = "Engine registration AZ 1"
      protocol         = "tcp"
      from_port        = 7070
      to_port          = 7070
      cidr_blocks      = [data.aws_subnet.private_subnet_az1.cidr_block]
    },
    {
      description      = "Engine registration AZ 2"
      protocol         = "tcp"
      from_port        = 7070
      to_port          = 7070
      cidr_blocks      = [data.aws_subnet.private_subnet_az2.cidr_block]
    }
  ]

  egress = [
    {
      description      = "allow all"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  tags = {
    "Name"    = "FME Server security group"
  }
}