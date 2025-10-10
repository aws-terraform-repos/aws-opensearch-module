output "domain_id" {
  description = "Unique identifier for the OpenSearch domain"
  value       = aws_opensearch_domain.this.domain_id
}

output "domain_name" {
  description = "Name of the OpenSearch domain"
  value       = aws_opensearch_domain.this.domain_name
}

output "arn" {
  description = "ARN of the OpenSearch domain"
  value       = aws_opensearch_domain.this.arn
}

output "domain_endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = aws_opensearch_domain.this.endpoint
}

output "dashboard_endpoint" {
  description = "Domain-specific endpoint for OpenSearch Dashboards"
  value       = try(aws_opensearch_domain.this.dashboard_endpoint, null)
}

output "vpc_id" {
  description = "VPC ID if the domain is in a VPC"
  value       = try(aws_opensearch_domain.this.vpc_options[0].vpc_id, null)
}

output "availability_zones" {
  description = "Availability zones used by the domain"
  value       = try(aws_opensearch_domain.this.vpc_options[0].availability_zones, null)
}
