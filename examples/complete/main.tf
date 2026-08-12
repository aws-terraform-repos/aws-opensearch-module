provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "opensearch" {
  name        = "complete-opensearch-sg"
  description = "Security group for OpenSearch domain"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "complete-opensearch-sg"
  }
}

resource "aws_cloudwatch_log_group" "opensearch_index_slow_logs" {
  name              = "/aws/opensearch/complete-domain/index-slow-logs"
  retention_in_days = 7

  tags = {
    Name = "opensearch-index-slow-logs"
  }
}

resource "aws_cloudwatch_log_group" "opensearch_search_slow_logs" {
  name              = "/aws/opensearch/complete-domain/search-slow-logs"
  retention_in_days = 7

  tags = {
    Name = "opensearch-search-slow-logs"
  }
}

resource "aws_cloudwatch_log_group" "opensearch_application_logs" {
  name              = "/aws/opensearch/complete-domain/application-logs"
  retention_in_days = 7

  tags = {
    Name = "opensearch-application-logs"
  }
}

resource "aws_cloudwatch_log_resource_policy" "opensearch" {
  policy_name = "complete-opensearch-log-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "es.amazonaws.com"
        }
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

data "aws_iam_policy_document" "access_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["es:*"]
    resources = ["arn:aws:es:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:domain/complete-opensearch-domain/*"]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = [data.aws_vpc.default.cidr_block]
    }
  }
}

module "opensearch" {
  source = "../.."

  domain_name    = "complete-opensearch-domain"
  engine_version = "OpenSearch_2.11"

  # Cluster configuration
  instance_type            = "r6g.large.search"
  instance_count           = 3
  dedicated_master_enabled = true
  dedicated_master_type    = "r6g.large.search"
  dedicated_master_count   = 3
  zone_awareness_enabled   = true
  availability_zone_count  = 3

  # VPC configuration
  vpc_options = {
    subnet_ids         = slice(data.aws_subnets.default.ids, 0, 3)
    security_group_ids = [aws_security_group.opensearch.id]
  }

  # EBS configuration
  ebs_enabled = true
  volume_size = 100
  volume_type = "gp3"
  throughput  = 250

  # Security settings
  encrypt_at_rest_enabled         = true
  node_to_node_encryption_enabled = true

  # Access policies
  access_policies = data.aws_iam_policy_document.access_policy.json

  # Log publishing
  log_publishing_options = [
    {
      log_type                 = "INDEX_SLOW_LOGS"
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_index_slow_logs.arn
    },
    {
      log_type                 = "SEARCH_SLOW_LOGS"
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_search_slow_logs.arn
    },
    {
      log_type                 = "ES_APPLICATION_LOGS"
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_application_logs.arn
    }
  ]

  # Advanced security options
  advanced_security_options = {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options = {
      master_user_name     = "admin"
      master_user_password = "Admin@123456!" # Change this in production!
    }
  }

  # Auto-tune options
  auto_tune_options = {
    desired_state       = "ENABLED"
    rollback_on_disable = "NO_ROLLBACK"
  }

  # Advanced options
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    "override_main_response_version"         = "false"
  }

  tags = {
    Environment = "production"
    Purpose     = "complete-example"
    ManagedBy   = "terraform"
  }

  depends_on = [aws_cloudwatch_log_resource_policy.opensearch]
}
