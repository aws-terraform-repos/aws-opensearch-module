# VPC OpenSearch Example

This example demonstrates deploying an OpenSearch domain within a VPC with proper security group configuration and multi-AZ support.

## Features

- Three-node OpenSearch cluster
- VPC deployment with security groups
- Multi-AZ deployment across 3 availability zones
- Enhanced EBS storage with gp3 volumes
- Encryption at rest and node-to-node encryption

## Usage

```bash
tofu init
tofu plan
tofu apply
```

## Clean Up

```bash
tofu destroy
```

## Notes

- This example uses the default VPC and subnets
- Ensure you have at least 3 subnets in different availability zones
- Security group allows HTTPS access from within the VPC
- For production, implement fine-grained access control
