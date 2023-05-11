terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

locals {
  git = "terraform-aws-alb"
}

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "public" {
  tags = {
    purpose = "vega"
    Type    = "Public"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.111-28fcc7c"
  git               = local.git
  domain_name       = "${local.git}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "this" {
  source          = "../../"
  git             = local.git
  certificate_arn = module.acm.arn
  subnet_ids      = data.aws_subnets.public.ids
  vpc_id          = data.aws_vpcs.this.ids[0]
  internal        = false
  protect         = false
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "app.py"
  output_path = "package.zip"
}

module "lambda" {
  source             = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.118-12b9f57"
  git                = var.git
  name               = "zip"
  filename           = data.archive_file.this.output_path
  handler            = "app.handler"
  runtime            = "python3.9"
  vpc_id             = data.aws_vpcs.this.ids[0]
  private_subnet_ids = data.aws_subnets.public.ids
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
