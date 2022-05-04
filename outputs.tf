output "security_group" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#id"
  value       = aws_security_group.this.id
}

output "listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn"
  value       = aws_lb_listener.https.arn
}

output "dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  value       = aws_lb.this.zone_id
}

output "bucket" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#bucket"
  value       = aws_s3_bucket.this.bucket
}
