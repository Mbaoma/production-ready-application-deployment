locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  common_tags        = local.common_tags
}

module "security_group" {
  source = "./modules/security_group"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  ssh_allowed_cidr = var.ssh_allowed_cidr
  common_tags      = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  common_tags  = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  project_name       = var.project_name
  github_repo        = var.github_repo
  github_branch      = var.github_branch
  ecr_repository_arn = module.ecr.repository_arn
  common_tags        = local.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  project_name         = var.project_name
  environment          = var.environment
  instance_type        = var.instance_type
  subnet_id            = module.network.public_subnet_id
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = module.iam.ec2_instance_profile_name
  ssh_public_key_path  = var.ssh_public_key_path
  aws_region           = var.aws_region
  ecr_repository_url   = module.ecr.repository_url
  cloudwatch_log_group = module.cloudwatch.log_group_name
  common_tags          = local.common_tags
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
  instance_id  = module.ec2.instance_id
  common_tags  = local.common_tags
}