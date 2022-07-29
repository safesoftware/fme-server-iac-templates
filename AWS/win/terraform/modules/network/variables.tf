variable "vpc_name" {
  type        = string
  description = "Virtual private cloud name"
}

variable "sn_name" {
  type        = string
  description = "Subnet name prefix"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR range for VPC"
}

variable "public_sn1_cidr" {
  type = string
  description = "CIDR range for public subnet in the first availability zone"
}

variable "public_sn2_cidr" {
  type = string
  description = "CIDR range for public subnet in the second availability zone"
}

variable "private_sn1_cidr" {
  type = string
  description = "CIDR range for private subnet in the first availability zone"
}

variable "private_sn2_cidr" {
  type = string
  description = "CIDR range for private subnet in the second availability zone"
}
variable "igw_name" {
  type        = string
  description = "Internet gateway name"
}

variable "eip_name" {
  type        = string
  description = "Elastic IP name"
}

variable "nat_name" {
  type        = string
  description = "NAT gateway name"
}
