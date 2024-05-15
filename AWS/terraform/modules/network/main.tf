data "aws_region" "current" {}

data "aws_vpc" "fme_server" {
  id = aws_vpc.fme_server.id
}

data "aws_subnet" "private_subnet_az1" {
  id = aws_subnet.private_subnet_az1.id
}

data "aws_subnet" "private_subnet_az2" {
  id = aws_subnet.private_subnet_az2.id
}

resource "aws_vpc" "fme_server" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = var.public_sn1_cidr
  availability_zone = format("%sa", data.aws_region.current.name)
  tags = {
    "Name" = format("%s-public1-%sa", var.sn_name, data.aws_region.current.name)
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = var.public_sn2_cidr
  availability_zone = format("%sb", data.aws_region.current.name)
  tags = {
    "Name" = format("%s-public2-%sb", var.sn_name, data.aws_region.current.name)
  }
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = var.private_sn1_cidr
  availability_zone = format("%sa", data.aws_region.current.name)
  tags = {
    "Name" = format("%s-private1-%sa", var.sn_name, data.aws_region.current.name)
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.fme_server.id
  cidr_block        = var.private_sn2_cidr
  availability_zone = format("%sb", data.aws_region.current.name)
  tags = {
    "Name" = format("%s-private2-%sb", var.sn_name, data.aws_region.current.name)
  }
}

resource "aws_internet_gateway" "fme_server" {
  vpc_id = aws_vpc.fme_server.id
  tags = {
    "Name" = var.igw_name
  }
}
resource "aws_eip" "fme_server_nat" {
  vpc              = true
  public_ipv4_pool = "amazon"
  tags = {
    "Name" = var.eip_name
  }
}

resource "aws_nat_gateway" "fme_server" {
  subnet_id     = aws_subnet.public_subnet_az1.id
  allocation_id = aws_eip.fme_server_nat.id
  tags = {
    "Name" = var.nat_name
  }
}

resource "aws_default_route_table" "fmeserver_default_rt" {
  default_route_table_id = aws_vpc.fme_server.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.fme_server.id
  }
  tags = {
    "Name" = "Private subnets route table"
  }
}

resource "aws_route_table_association" "private_subnet_az1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_default_route_table.fmeserver_default_rt.id
}

resource "aws_route_table_association" "private_subnet_az2" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_default_route_table.fmeserver_default_rt.id
}

resource "aws_route_table" "fmeserver_public_rt" {
  vpc_id = aws_vpc.fme_server.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fme_server.id
  }
  tags = {
    "Name" = "Public subnets route table"
  }
}

resource "aws_route_table_association" "public_subnet_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.fmeserver_public_rt.id
}

resource "aws_route_table_association" "public_subnet_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.fmeserver_public_rt.id
}

resource "aws_db_subnet_group" "rds_subnet_roup" {
  name_prefix = "fmedbsubnetgroup"
  subnet_ids  = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id]
  tags = {
    "Name" = "RDS subnet group"
  }
}

resource "aws_security_group" "fmeserver" {
  vpc_id      = aws_vpc.fme_server.id
  name        = "FME Flow security group"
  description = "Allows communication between FME Flow components"

  ingress = [
    {
      description      = "Allow all traffic between EC2, ALB, RDS & FSx in VPC"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      self             = true
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "Web UI from local IP"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = [var.public_access]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false

    },
    {
      description      = "Web socket from local IP"
      protocol         = "tcp"
      from_port        = 7078
      to_port          = 7078
      cidr_blocks      = [var.public_access]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Web UI from NAT gateway"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = [format("%s/32", aws_eip.fme_server_nat.public_ip)]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Engine registration health check"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = [data.aws_vpc.fme_server.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Engine registration AZ 1"
      protocol         = "tcp"
      from_port        = 7070
      to_port          = 7070
      cidr_blocks      = [data.aws_subnet.private_subnet_az1.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Engine registration AZ 2"
      protocol         = "tcp"
      from_port        = 7070
      to_port          = 7070
      cidr_blocks      = [data.aws_subnet.private_subnet_az2.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "allow all"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    "Name" = "FME Flow security group"
  }
}