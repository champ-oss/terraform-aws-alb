module "s3" {
  source                       = "github.com/champ-oss/terraform-aws-s3.git?ref=69c71919ed14515fcba747f8826f2e79c660f8d7"
  git                          = var.git
  name                         = "lb"
  protect                      = var.protect
  enable_lb_policy             = true
  expiration_lifecycle_enabled = true
  expiration_lifecycle_days    = var.log_retention
  expiration_lifecycle_prefix  = "/"
}
