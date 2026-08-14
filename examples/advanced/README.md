# Complete OpenSearch Example

This example demonstrates a production-ready OpenSearch domain configuration with all major features enabled.

## Features

- Six-node cluster (3 data nodes + 3 dedicated master nodes)
- VPC deployment with security groups
- Multi-AZ deployment across 3 availability zones
- Enhanced EBS storage with gp3 volumes (100GB per node)
- Encryption at rest and node-to-node encryption
- Fine-grained access control with internal user database
- CloudWatch log publishing (index slow logs, search slow logs, application logs)
- Auto-tune enabled
- Custom access policies
- Advanced options configured

## Usage

**Important:** Change the `master_user_password` in `main.tf` before deploying to production!

```bash
tofu init
tofu plan
tofu apply
```

## Clean Up

```bash
tofu destroy
```

## Security Notes

- Fine-grained access control is enabled with an internal user database
- The example uses a placeholder password that should be changed
- Consider using AWS Secrets Manager or AWS Systems Manager Parameter Store for password management
- Access policies restrict access based on VPC CIDR block
- All encryption options are enabled

## Cost Considerations

This is a production-ready configuration using r6g.large.search instances, which may incur significant AWS costs. Review the pricing for:
- OpenSearch instance hours
- EBS storage (100GB per node × 6 nodes)
- Data transfer
- CloudWatch Logs storage

## Monitoring

CloudWatch log groups are configured for:
- Index slow logs
- Search slow logs
- Application logs

Monitor these logs to optimize performance and troubleshoot issues.
