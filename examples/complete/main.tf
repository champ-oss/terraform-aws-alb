provider "aws" {
  region = "us-east-1"
}

locals {
  git = "terraform-aws-alb"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=v1.0.4-bfc0ea5"
  git                      = local.git
  availability_zones_count = 2
  retention_in_days        = 1
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.8-45ac9b3"
  git               = local.git
  domain_name       = data.aws_route53_zone.this.name
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "this" {
  source          = "../../"
  git             = local.git
  certificate_arn = module.acm.arn
  subnet_ids      = module.vpc.public_subnets_ids
  vpc_id          = module.vpc.vpc_id
  internal        = false
  protect         = false
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "app.py"
  output_path = "package.zip"
}

module "lambda" {
  source             = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.1-719523e"
  git                = var.git
  name               = "zip"
  filename           = data.archive_file.this.output_path
  handler            = "app.handler"
  runtime            = "python3.9"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets_ids
  zone_id            = data.aws_route53_zone.this.zone_id

  # Make the lambda public by attaching to the ALB
  listener_arn         = module.this.listener_arn
  lb_dns_name          = module.this.dns_name
  lb_zone_id           = module.this.zone_id
  enable_load_balancer = true
  enable_route53       = true
  enable_vpc           = false
  dns_name             = "terraform-aws-alb.oss.champtest.net"
}
