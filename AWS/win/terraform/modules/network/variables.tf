variable "vpc_name" {
  type        = string
  description = "Virtual private cloud name"
}

variable "sn_name" {
  type        = string
  description = "Subnet name prefix"
}
variable "igw_name" {
  type = string
  description = "Internet gateway name"
}

variable "eip_name" {
  type = string
  description = "Elastic IP name"  
}

variable "nat_name" {
  type = string
  description = "NAT gateway name"
}
