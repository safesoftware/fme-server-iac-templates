variable "nlb_name" {
  type = string
  description = "Name of the network load balancer"
}

variable "sg_id" {
  type = string
  description = "Security group id for FME Server deployment"
}

variable "vpc_id" {
  type = string
  description = "VPC id for FME Sever deployment"
}

variable "private_sn_az2_id" {
  type = string
  description = "Private subnet id in the second availability zone"
}

variable "private_sn_az1_id" {
  type = string
  description = "Private subnet id in the first availability zone"
}