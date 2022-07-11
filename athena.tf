resource "aws_athena_database" "this" {
  name   = replace(aws_lb.this.name, "-", "_")
  bucket = module.s3.bucket
  force_destroy = !var.protect
}

resource "aws_athena_named_query" "this" {
  name      = aws_lb.this.name
  workgroup = "primary"
  database  = aws_athena_database.this.name
  query = templatefile("${path.module}/athena-create-table.tftpl",
    {
      bucket_location = "s3://${module.s3.bucket}/AWSLogs/${data.aws_caller_identity.this.account_id}/elasticloadbalancing/${data.aws_region.this.name}"
    })
}