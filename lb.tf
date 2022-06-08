resource "aws_lb" "this" {
  depends_on      = [module.s3]
  name_prefix     = var.internal ? "lb-pv-" : "lb-pb-"
  security_groups = [aws_security_group.this.id]
  subnets         = var.subnet_ids
  tags            = merge(local.tags, var.tags)
  internal        = var.internal

  access_logs {
    bucket  = module.s3.bucket
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  depends_on        = [aws_lb.this] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
  port              = "80"
  protocol          = "HTTP"
  tags              = merge(local.tags, var.tags)

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  depends_on        = [aws_lb.this] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  tags              = merge(local.tags, var.tags)

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No valid routing rule"
      status_code  = "400"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_certificate" "this" {
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}