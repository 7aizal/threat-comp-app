
# main config 

# vpc
module "vpc" {
  source = "./modules/vpc"

  vpc_name            = var.vpc_name
  vpc_cidr_block      = var.vpc_cidr_block

  public_subnet_cidrs = var.public_subnet_cidrs
  public_subnet_azs   = var.public_subnet_azs

  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_azs   = var.private_subnet_azs

  region = var.region
  tags   = var.tags

}

# security groups
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
  region = var.region
  cidr_block = module.vpc.vpc_cidr_block
}

# alb
module "alb" {
  source = "./modules/alb"

  alb_name             = var.alb_name
  internal             = var.internal
  load_balancer_type   = var.load_balancer_type

  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  alb_security_group_id = module.sg.alb_sg_id

  tg_name      = var.tg_name
  tg_port      = var.tg_port
  tg_protocol  = var.tg_protocol
  target_type  = var.target_type

  health_check_path       = var.health_check_path
  health_check_protocol   = var.health_check_protocol
  matcher                 = var.matcher
  health_check_interval   = var.health_check_interval
  health_check_timeout    = var.health_check_timeout
  healthy_threshold       = var.healthy_threshold
  unhealthy_threshold     = var.unhealthy_threshold

  acm_certificate_arn = var.acm_certificate_arn

  tags   = var.common_tags
  region = var.region
}

# iam
module "iam" {
  source = "./modules/iam"
  tags   = var.common_tags
  region = var.region
}

# ecs
module "ecs" {
  source = "./modules/ecs"

  cluster_name         = var.cluster_name
  private_subnet_ids   = module.vpc.private_subnet_ids
  ecs_security_group_id = module.sg.ecs_sg_id
  vpc_id = module.vpc.vpc_id
  tg_arn             = module.alb.tg_arn
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn

  container_name   = var.container_name
  container_image  = var.container_image
  container_port   = var.container_port
  desired_count    = var.desired_count

  tags = var.common_tags
  alb_security_group_id = module.sg.alb_sg_id
  alb_target_group_arn = module.alb.tg_arn
  region = var.region
  ecs_cpu = var.ecs_cpu
  ecs_memory = var.ecs_memory
  
 
}
# acm
module "acm" {
  source = "./modules/acm"

  domain_name     = var.domain_name
  subject_alternative_names = var.san_domains
  tags = var.common_tags
  region = var.region
}

# dns
module "dns" {
  source = "./modules/dns"
  zone_id = var.cloudflare_zone_id
  validation_records = module.acm.domain_validation_options
  cloudflare_api_token = var.cloudflare_api_token
  
}

# s3 bucket
module "s3" {
  source = "./modules/s3"

  s3_bucket_name = var.s3_bucket_name
  tags           = var.common_tags
  region = var.region
}


