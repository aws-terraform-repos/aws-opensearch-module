# AWS OpenSearch Terraform Module

A comprehensive Terraform module for deploying and managing AWS OpenSearch domains with best practices and DRY principles.

## Features

- ✅ Full AWS OpenSearch domain configuration support
- ✅ VPC and public endpoint deployment options
- ✅ Multi-AZ deployment with zone awareness
- ✅ Dedicated master nodes support
- ✅ EBS volume configuration (gp2, gp3, io1, io2)
- ✅ Encryption at rest and node-to-node encryption
- ✅ Fine-grained access control
- ✅ CloudWatch log publishing
- ✅ Auto-tune configuration
- ✅ Cognito authentication support
- ✅ Custom endpoint configuration
- ✅ Comprehensive examples (basic, VPC, complete)

## Usage

### Basic Example

```hcl
module "opensearch" {
  source = "github.com/aws-terraform-repos/aws-opensearch-module"

  domain_name = "my-opensearch-domain"
  
  instance_type  = "t3.small.search"
  instance_count = 1

  # Security settings
  encrypt_at_rest_enabled         = true
  node_to_node_encryption_enabled = true

  tags = {
    Environment = "dev"
  }
}
```

### VPC Deployment Example

```hcl
module "opensearch" {
  source = "github.com/aws-terraform-repos/aws-opensearch-module"

  domain_name = "my-opensearch-domain"

  instance_type  = "t3.small.search"
  instance_count = 3

  zone_awareness_enabled  = true
  availability_zone_count = 3

  vpc_options = {
    subnet_ids         = ["subnet-12345", "subnet-67890", "subnet-abcde"]
    security_group_ids = ["sg-12345"]
  }

  ebs_enabled = true
  volume_size = 30
  volume_type = "gp3"
  throughput  = 125

  tags = {
    Environment = "production"
  }
}
```

## Examples

This module includes three complete examples:

- **[basic](./examples/basic/)** - Minimal configuration for development/testing
- **[vpc](./examples/vpc/)** - VPC deployment with security groups
- **[complete](./examples/complete/)** - Production-ready configuration with all features

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain_name | Name of the OpenSearch domain | `string` | n/a | yes |
| engine_version | OpenSearch or Elasticsearch engine version | `string` | `"OpenSearch_2.11"` | no |
| instance_type | Instance type for OpenSearch cluster nodes | `string` | `"t3.small.search"` | no |
| instance_count | Number of instances in the OpenSearch cluster | `number` | `3` | no |
| dedicated_master_enabled | Whether dedicated master nodes are enabled | `bool` | `false` | no |
| dedicated_master_type | Instance type for dedicated master nodes | `string` | `"t3.small.search"` | no |
| dedicated_master_count | Number of dedicated master nodes | `number` | `3` | no |
| zone_awareness_enabled | Whether zone awareness is enabled | `bool` | `true` | no |
| availability_zone_count | Number of availability zones for the domain | `number` | `3` | no |
| ebs_enabled | Whether EBS volumes are attached to data nodes | `bool` | `true` | no |
| volume_type | Type of EBS volumes attached to data nodes | `string` | `"gp3"` | no |
| volume_size | Size of EBS volumes attached to data nodes (in GB) | `number` | `20` | no |
| iops | Baseline I/O performance of EBS volumes (required for io1/io2) | `number` | `null` | no |
| throughput | Throughput (in MiB/s) of the EBS volumes (required for gp3) | `number` | `null` | no |
| encrypt_at_rest_enabled | Whether to enable encryption at rest | `bool` | `true` | no |
| encrypt_at_rest_kms_key_id | KMS key ID for encryption at rest | `string` | `null` | no |
| node_to_node_encryption_enabled | Whether node-to-node encryption is enabled | `bool` | `true` | no |
| vpc_options | VPC options for the OpenSearch domain | `object` | `null` | no |
| advanced_options | Key-value map of advanced options | `map(string)` | `{}` | no |
| access_policies | IAM policy document for domain access | `string` | `null` | no |
| log_publishing_options | Configuration for publishing logs to CloudWatch | `list(object)` | `[]` | no |
| auto_tune_options | Configuration block for Auto-Tune options | `object` | `null` | no |
| advanced_security_options | Configuration for fine-grained access control | `object` | `null` | no |
| cognito_options | Configuration for Cognito authentication | `object` | `null` | no |
| domain_endpoint_options | Configuration for domain endpoint options | `object` | See variables.tf | no |
| snapshot_options | Configuration for snapshot options | `object` | `{ automated_snapshot_start_hour = 0 }` | no |
| tags | Map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain_id | Unique identifier for the OpenSearch domain |
| domain_name | Name of the OpenSearch domain |
| arn | ARN of the OpenSearch domain |
| domain_endpoint | Domain-specific endpoint used to submit index, search, and data upload requests |
| dashboard_endpoint | Domain-specific endpoint for OpenSearch Dashboards |
| vpc_id | VPC ID if the domain is in a VPC |
| availability_zones | Availability zones used by the domain |

## Testing

This module uses [Task](https://taskfile.dev) for automation. Install Task and run:

```bash
# Show available tasks
task

# Format Terraform files
task fmt

# Validate module
task validate

# Validate all examples
task validate-examples

# Run all tests
task test

# Run CI pipeline
task ci
```

### Available Tasks

- `task fmt` - Format all Terraform files
- `task fmt-check` - Check if all files are formatted
- `task validate` - Validate the module
- `task validate-examples` - Validate all example configurations
- `task lint` - Run TFLint (requires installation)
- `task security` - Run tfsec security scanner (requires installation)
- `task docs` - Generate documentation (requires terraform-docs)
- `task test` - Run all tests
- `task ci` - Run CI pipeline
- `task clean` - Clean up Terraform files

## Development

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Task](https://taskfile.dev) (optional, for automation)
- [TFLint](https://github.com/terraform-linters/tflint) (optional, for linting)
- [tfsec](https://github.com/aquasecurity/tfsec) (optional, for security scanning)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs) (optional, for documentation)

### GitHub Copilot

This repository includes custom instructions for GitHub Copilot in `.github/copilot-instructions.md` to help maintain consistency and best practices.

## Security Best Practices

- Always enable encryption at rest (`encrypt_at_rest_enabled = true`)
- Always enable node-to-node encryption (`node_to_node_encryption_enabled = true`)
- Deploy in VPC for production workloads
- Use fine-grained access control for sensitive data
- Implement proper IAM policies and security groups
- Enable CloudWatch log publishing for monitoring
- Use AWS Secrets Manager or Parameter Store for sensitive values
- Regularly review and update security configurations

## Contributing

Contributions are welcome! Please ensure:

1. Code is formatted with `terraform fmt`
2. All tests pass (`task test`)
3. Documentation is updated
4. Examples are provided for new features

## License

This module is licensed under the MIT License.

## Authors

Maintained by the AWS Terraform Repos team.

## Support

For issues and questions:
- Open an issue in the GitHub repository
- Review existing examples in the `examples/` directory
- Check AWS OpenSearch documentation