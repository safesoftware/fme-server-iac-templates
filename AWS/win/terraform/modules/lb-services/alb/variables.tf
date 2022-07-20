variable "alb_name" {
  type = string
  description = "Name of the application load balancer"
}

variable "sg_id" {
  type = string
  description = "Security group id for FME Server deployment"
}

variable "vpc_id" {
  type = string
  description = "VPC id for FME Sever deployment"
}

variable "public_sn_az2_id" {
  type = string
  description = "Public subnet id in the second availability zone"
}

variable "public_sn_az1_id" {
  type = string
  description = "Public subnet id in the first availability zone"
}