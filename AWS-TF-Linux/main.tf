terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
}

variable "key_name" {
  type = string
}

data "template_file" "mainScript" {
  template = file("./install_fme.sh.tpl")
  vars = {
    efs        = aws_efs_file_system.newEFS.id
    eip        = aws_eip.newEIP.public_ip
    rdsAddress = aws_db_instance.newRDS.address
    rdsPort    = aws_db_instance.newRDS.port
  }
}

data "template_file" "engineScript" {
  template = file("./install_engine.sh.tpl")
  vars = {
    efs        = aws_efs_file_system.newEFS.id
    eip        = aws_eip.newEIP.public_ip
    rdsAddress = aws_db_instance.newRDS.address
    rdsPort    = aws_db_instance.newRDS.port
  }
}

resource "aws_vpc" "newVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "newInternetGateway" {
  vpc_id = aws_vpc.newVPC.id
}

resource "aws_route" "defaultPublicRoute" {
  route_table_id         = aws_vpc.newVPC.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.newInternetGateway.id
}

resource "aws_subnet" "mainSubnet" {
  vpc_id            = aws_vpc.newVPC.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ca-central-1a"
}

resource "aws_subnet" "dbSubnet" {
  vpc_id            = aws_vpc.newVPC.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ca-central-1b"
}

resource "aws_db_subnet_group" "rdsSubnetGroup" {
  subnet_ids = [aws_subnet.mainSubnet.id, aws_subnet.dbSubnet.id]
}

resource "aws_route_table_association" "associateSubnet" {
  subnet_id      = aws_subnet.mainSubnet.id
  route_table_id = aws_vpc.newVPC.default_route_table_id
}

resource "aws_security_group" "newSG" {
  vpc_id      = aws_vpc.newVPC.id
  name        = "testSG"
  description = "template tests security group"

  ingress = [
    {
      description      = "HTTP"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "WebUI"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Core and Engine"
      protocol         = "tcp"
      from_port        = 7500
      to_port          = 7501
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Pool"
      protocol         = "tcp"
      from_port        = 7100
      to_port          = 7200
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "misc requests/triggers"
      protocol         = "tcp"
      from_port        = 7069
      to_port          = 7082
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Queue control"
      protocol         = "tcp"
      from_port        = 6379
      to_port          = 6379
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "HTTPS"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "FTP/SSH"
      protocol         = "tcp"
      from_port        = 20
      to_port          = 22
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "self"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  egress = [
    {
      description      = "allow all"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_db_instance" "newRDS" {
  allocated_storage      = 20
  availability_zone      = "ca-central-1a"
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  username               = "postgres"
  password               = "postgres"
  db_subnet_group_name   = aws_db_subnet_group.rdsSubnetGroup.id
  license_model          = "postgresql-license"
  port                   = 5432
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.newSG.id]
  skip_final_snapshot    = true
}

resource "aws_efs_file_system" "newEFS" {
  availability_zone_name = "ca-central-1a"
}

resource "aws_efs_mount_target" "newMountTarget" {
  file_system_id  = aws_efs_file_system.newEFS.id
  subnet_id       = aws_subnet.mainSubnet.id
  security_groups = [aws_security_group.newSG.id]
}

resource "aws_eip" "newEIP" {
  vpc = true
}

resource "aws_instance" "mainServer" {
  ami                    = "ami-0801628222e2e96d6"
  availability_zone      = "ca-central-1a"
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.newSG.id]
  subnet_id              = aws_subnet.mainSubnet.id
  root_block_device {
    volume_size = 20
  }
  user_data = data.template_file.mainScript.rendered
  depends_on = [
    aws_db_instance.newRDS,
    aws_efs_mount_target.newMountTarget,
    aws_eip.newEIP
  ]
}

resource "aws_instance" "engineServer" {
  ami                         = "ami-0801628222e2e96d6"
  availability_zone           = "ca-central-1a"
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.newSG.id]
  subnet_id                   = aws_subnet.mainSubnet.id
  root_block_device {
    volume_size = 20
  }
  user_data = data.template_file.engineScript.rendered
  depends_on = [
    aws_instance.mainServer
  ]
}

resource "aws_eip_association" "associateEIP" {
  allocation_id = aws_eip.newEIP.id
  instance_id   = aws_instance.mainServer.id
}