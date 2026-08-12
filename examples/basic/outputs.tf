output "domain_endpoint" {
  description = "OpenSearch domain endpoint"
  value       = module.opensearch.domain_endpoint
}

output "domain_arn" {
  description = "OpenSearch domain ARN"
  value       = module.opensearch.arn
}

output "dashboard_endpoint" {
  description = "OpenSearch Dashboards endpoint"
  value       = module.opensearch.dashboard_endpoint
}
