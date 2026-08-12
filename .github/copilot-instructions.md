# GitHub Copilot Instructions for AWS OpenSearch OpenTofu Module

## General Guidelines

- Use HashiCorp Configuration Language (HCL) syntax for all OpenTofu configuration files
- Follow OpenTofu/Terraform best practices and naming conventions
- Maintain DRY (Don't Repeat Yourself) principles throughout the codebase
- Use double quotes for all string values in HCL

## Code Structure

- Organize OpenTofu resources logically in separate files:
  - `main.tf`: Primary resource definitions
  - `variables.tf`: Input variable declarations
  - `outputs.tf`: Output value definitions
  - `versions.tf`: OpenTofu and provider version constraints
- Use meaningful and descriptive names for resources, variables, and outputs
- Group related resources together using comments when necessary

## Variables

- Always provide descriptions for all variables
- Set appropriate default values when sensible
- Use validation blocks for variables that have specific requirements
- Use `type` constraints to ensure type safety
- Use `optional()` for object attributes that are not required

## Resource Configuration

- Use `dynamic` blocks to handle optional nested configurations
- Prefer using `for_each` over `count` for creating multiple similar resources
- Always enable encryption at rest and in transit for production resources
- Use conditional expressions to handle optional resource attributes

## Security Best Practices

- Enable encryption by default for all OpenSearch domains
- Use VPC deployments for production workloads
- Implement fine-grained access control when available
- Never hardcode sensitive values like passwords; use variables or reference external secret managers
- Use security groups to restrict network access appropriately

## Examples

- Provide multiple example configurations demonstrating different use cases:
  - Basic: Minimal configuration for development/testing
  - VPC: VPC-deployed configuration with security groups
  - Complete: Production-ready configuration with all features
- Each example should include:
  - `main.tf`: Example usage of the module
  - `outputs.tf`: Relevant outputs
  - `README.md`: Documentation explaining the example

## Documentation

- Include comprehensive README.md files at the root and in example directories
- Document all input variables with descriptions, types, and defaults
- Document all outputs with descriptions
- Provide usage examples in documentation
- Include prerequisites and requirements

## Testing

- Use Taskfile.yml for automation of common tasks
- Validate OpenTofu configurations before committing
- Format all OpenTofu files using `tofu fmt`
- Test module with different configurations

## Comments

- Add comments to explain complex logic or non-obvious configurations
- Use comments sparingly; prefer self-documenting code
- Document any workarounds or known limitations

## Tags

- Always support resource tagging through a `tags` variable
- Use consistent tag keys across resources (e.g., Environment, ManagedBy, Purpose)
- Pass tags to all resources that support tagging

## Module Design

- Keep the module focused on AWS OpenSearch domain management
- Make the module reusable and composable
- Provide sensible defaults while allowing full customization
- Use feature flags (boolean variables) to enable/disable optional features
