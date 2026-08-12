# Basic OpenSearch Example

This example demonstrates a basic OpenSearch domain configuration with minimal settings suitable for development and testing environments.

## Features

- Single node OpenSearch cluster
- Basic EBS storage configuration
- Encryption at rest and node-to-node encryption enabled
- Public endpoint (not in VPC)

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

This configuration is suitable for development and testing only. For production use, consider:
- Multi-node cluster with zone awareness
- VPC deployment for network isolation
- Fine-grained access control
- CloudWatch log publishing
