provider "aws" {
  region = "us-east-1"
}

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
  name        = "opensearch-sg"
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
    Name = "opensearch-sg"
  }
}

module "opensearch" {
  source = "../.."

  domain_name = "vpc-opensearch-domain"

  instance_type  = "t3.small.search"
  instance_count = 3

  # Enable zone awareness
  zone_awareness_enabled  = true
  availability_zone_count = 3

  # VPC configuration
  vpc_options = {
    subnet_ids         = slice(data.aws_subnets.default.ids, 0, 3)
    security_group_ids = [aws_security_group.opensearch.id]
  }

  # EBS configuration
  ebs_enabled = true
  volume_size = 30
  volume_type = "gp3"
  throughput  = 125

  # Security settings
  encrypt_at_rest_enabled         = true
  node_to_node_encryption_enabled = true

  tags = {
    Environment = "staging"
    Purpose     = "vpc-example"
  }
}
