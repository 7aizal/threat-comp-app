################################
# Terraform Main Configuration  #
################################

module "vpc" {
  source = "./modules/vpc"
  vpc_name = module.vpc_name
  vpc_cidr_block = module.vpc_cidr_block
  region = module.availability_zones
  public_subnet_cidr_2a = module.public_subnet_cidr_2a
  public_subnet_cidr_2b = module.public_subnet_cidr_2b
  private_subnet_cidrs = module.private_subnet_cidrs
}

module "ACM" {
  source = "./modules/acm"
  domain_name = module.domain_name
  route53_zone_id = module.route53_zone_id
  tags = {
    Environment = "production"
    Project     = "threat-composser-app"
  }
  certificate_arn = module.certificate_arn
  validation_record_fqdns = module.validation_record_fqdns
  domain_validation_options = module.domain_validation_options
  validation_method = "DNS"
}

 