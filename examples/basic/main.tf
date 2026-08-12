provider "aws" {
  region = "us-east-1"
}

# atlantis config test - safe to remove after verifying autoplan

module "opensearch" {
  source = "../.."

  domain_name = "basic-opensearch-domain"

  instance_type  = "t3.small.search"
  instance_count = 1

  # Disable zone awareness for single node
  zone_awareness_enabled = false

  # Basic EBS configuration
  ebs_enabled = true
  volume_size = 20
  volume_type = "gp3"

  # Security settings
  encrypt_at_rest_enabled         = true
  node_to_node_encryption_enabled = true

  tags = {
    Environment = "dev"
    Purpose     = "testing"
  }
}
