resource "aws_vpc" "FMEVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"    = "FMEVPC"
  }
}

resource "aws_internet_gateway" "FMEInternetGateway" {
  vpc_id = aws_vpc.FMEVPC.id
  tags = {
    "Name"    = "FMEInternetGateway"
  }
}

resource "aws_route" "defaultPublicRoute" {
  route_table_id         = aws_vpc.FMEVPC.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.FMEInternetGateway.id
}

resource "aws_subnet" "mainSubnet" {
  vpc_id            = aws_vpc.FMEVPC.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ca-central-1a"
  tags = {
    "Name"    = "FMEmainSubnet"
  }
}

resource "aws_subnet" "dbSubnet" {
  vpc_id            = aws_vpc.FMEVPC.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ca-central-1b"
  tags = {
    "Name"    = "FMEDBSubnet"
  }
}

resource "aws_db_subnet_group" "rdsSubnetGroup" {
  subnet_ids = [aws_subnet.mainSubnet.id, aws_subnet.dbSubnet.id]
  tags = {
    "Name"    = "FMEDBSubnetGroup"
  }
}

resource "aws_route_table_association" "associateSubnet" {
  subnet_id      = aws_subnet.mainSubnet.id
  route_table_id = aws_vpc.FMEVPC.default_route_table_id
}

resource "aws_security_group" "FMEServerSecurityGroup" {
  vpc_id      = aws_vpc.FMEVPC.id
  name        = "FMEServerSecurityGroup"
  description = "Allows communication between FME components"

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
      from_port        = 7200
      to_port          = 7300
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SMPT unsecured"
      protocol         = "tcp"
      from_port        = 7125
      to_port          = 7125
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
      description      = "SMTP secured"
      protocol         = "tcp"
      from_port        = 465
      to_port          = 465
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
      cidr_blocks      = []
      ipv6_cidr_blocks = []
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

  tags = {
    "Name"    = "FMEServerSecurityGroup"
  }
}

output "securityGroupID" {
  value = aws_security_group.FMEServerSecurityGroup.id
}

output "vpcID" {
  value = aws_vpc.FMEVPC.id
}

output "subnet" {
  value = aws_subnet.mainSubnet.id
}

output "dbSubnet" {
  value = aws_db_subnet_group.rdsSubnetGroup.id
}