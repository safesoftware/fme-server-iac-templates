terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
  default_tags {
    tags = {
      "Owner" = var.owner
    }
  }
}

module "network" {
  source   = "./modules/network/"
  vpc_name = var.vpc_name
  sn_name  = var.sn_name
  igw_name = var.igw_name
  eip_name = var.eip_name
  nat_name = var.nat_name
}

module "storage" {
  source            = "./modules/storage/"
  ad_name           = var.ad_name
  ad_admin_pw       = var.ad_admin_pw
  vpc_id            = module.network.vpc_id
  private_sn_az2_id = module.network.private_sn_az2_id
  private_sn_az1_id = module.network.private_sn_az1_id
  sg_id             = module.network.sg_id
}

module "database" {
  source            = "./modules/database/"
  db_admin_user     = var.db_admin_user
  db_admin_pw       = var.db_admin_pw
  rds_sn_group_name = module.network.rds_sn_group_name
  sg_id             = module.network.sg_id
}

module "alb" {
  source           = "./modules/lb-services/alb/"
  alb_name         = var.alb_name
  sg_id            = module.network.sg_id
  vpc_id           = module.network.vpc_id
  public_sn_az2_id = module.network.public_sn_az2_id
  public_sn_az1_id = module.network.public_sn_az1_id
}

module "nlb" {
  source            = "./modules/lb-services/nlb/"
  nlb_name          = var.nlb_name
  vpc_id            = module.network.vpc_id
  private_sn_az2_id = module.network.private_sn_az2_id
  private_sn_az1_id = module.network.private_sn_az1_id
}

module "iam" {
  source          = "./modules/iam/"
  rds_secrets_arn = module.secrets.rds_secrets_arn
  fsx_secrets_arn = module.secrets.fsx_secrets_arn
}

module "secrets" {
  source        = "./modules/secrets/"
  fsx_dns_name  = module.storage.fsx_dns_name
  db_dns_name   = module.database.db_dns_name
  ad_admin_pw   = var.ad_admin_pw
  db_admin_user = var.db_admin_user
  db_admin_pw   = var.db_admin_pw
}

module "asg_core" {
  source                               = "./modules/asg/asg_core/"
  vpc_name                             = var.vpc_name
  fme_core_image_id                    = var.fme_core_image_id
  sg_id                                = module.network.sg_id
  iam_instance_profile                 = module.iam.iam_instance_profile
  rds_secrets_arn                      = module.secrets.rds_secrets_arn
  fsx_secrets_arn                      = module.secrets.fsx_secrets_arn
  ssm_document_name                    = module.storage.ssm_document_name
  alb_dns_name                         = module.alb.alb_dns_name
  core_target_group_arn                = module.alb.core_target_group_arn
  websocket_target_group_arn           = module.alb.websocket_target_group_arn
  engine_registration_target_group_arn = module.nlb.engine_registration_target_group_arn
  private_sn_az2_id                    = module.network.private_sn_az2_id
  private_sn_az1_id                    = module.network.private_sn_az1_id
}

module "asg_engine" {
  source               = "./modules/asg/asg_engine/"
  vpc_name             = var.vpc_name
  fme_engine_image_id  = var.fme_engine_image_id
  sg_id                = module.network.sg_id
  iam_instance_profile = module.iam.iam_instance_profile
  rds_secrets_arn      = module.secrets.rds_secrets_arn
  fsx_secrets_arn      = module.secrets.fsx_secrets_arn
  ssm_document_name    = module.storage.ssm_document_name
  nlb_dns_name         = module.nlb.nlb_dns_name
  private_sn_az2_id    = module.network.private_sn_az2_id
  private_sn_az1_id    = module.network.private_sn_az1_id
}
