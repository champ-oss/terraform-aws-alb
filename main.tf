locals {
  tags = {
    git     = var.git
    cost    = "shared"
    creator = "terraform"
  }
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}