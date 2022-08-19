# terraform-aws-alb
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.71.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.71.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3"></a> [s3](#module\_s3) | github.com/champ-oss/terraform-aws-s3.git | v1.0.20-34f2235 |

## Resources

| Name | Type |
|------|------|
| [aws_athena_database.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_athena_named_query.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_certificate_arns"></a> [additional\_certificate\_arns](#input\_additional\_certificate\_arns) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate#certificate_arn | `list(string)` | `[]` | no |
| <a name="input_athena_workgroup"></a> [athena\_workgroup](#input\_athena\_workgroup) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query#workgroup | `string` | `"primary"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#certificate_arn | `string` | n/a | yes |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#cidr_blocks | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_git"></a> [git](#input\_git) | Identifier to be used on all resources | `string` | n/a | yes |
| <a name="input_internal"></a> [internal](#input\_internal) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#internal | `bool` | `true` | no |
| <a name="input_log_retention"></a> [log\_retention](#input\_log\_retention) | Retention period in days for both ALB and container logs | `number` | `90` | no |
| <a name="input_protect"></a> [protect](#input\_protect) | Enables deletion protection on eligible resources | `bool` | `true` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#ssl_policy | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#subnets | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#bucket |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name |
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#id |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id |
<!-- END_TF_DOCS -->