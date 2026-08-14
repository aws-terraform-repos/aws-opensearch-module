variable "domain_name" {
  description = "Name of the OpenSearch domain"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,27}$", var.domain_name))
    error_message = "Domain name must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens. Length must be between 3 and 28 characters."
  }
}

variable "engine_version" {
  description = "OpenSearch or Elasticsearch engine version"
  type        = string
  default     = "OpenSearch_2.11"
}

variable "instance_type" {
  description = "Instance type for OpenSearch cluster nodes"
  type        = string
  default     = "t3.small.search"
}

variable "instance_count" {
  description = "Number of instances in the OpenSearch cluster"
  type        = number
  default     = 3
}

variable "dedicated_master_enabled" {
  description = "Whether dedicated master nodes are enabled"
  type        = bool
  default     = false
}

variable "dedicated_master_type" {
  description = "Instance type for dedicated master nodes"
  type        = string
  default     = "t3.small.search"
}

variable "dedicated_master_count" {
  description = "Number of dedicated master nodes"
  type        = number
  default     = 3
}

variable "zone_awareness_enabled" {
  description = "Whether zone awareness is enabled"
  type        = bool
  default     = true
}

variable "availability_zone_count" {
  description = "Number of availability zones for the domain"
  type        = number
  default     = 3

  validation {
    condition     = contains([2, 3], var.availability_zone_count)
    error_message = "Availability zone count must be 2 or 3."
  }
}

variable "ebs_enabled" {
  description = "Whether EBS volumes are attached to data nodes"
  type        = bool
  default     = true
}

variable "volume_type" {
  description = "Type of EBS volumes attached to data nodes"
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.volume_type)
    error_message = "Volume type must be one of: gp2, gp3, io1, io2."
  }
}

variable "volume_size" {
  description = "Size of EBS volumes attached to data nodes (in GB)"
  type        = number
  default     = 20
}

variable "iops" {
  description = "Baseline input/output (I/O) performance of EBS volumes. Required for io1 and io2 volume types"
  type        = number
  default     = null
}

variable "throughput" {
  description = "Throughput (in MiB/s) of the EBS volumes. Required for gp3 volume type"
  type        = number
  default     = null
}

variable "encrypt_at_rest_enabled" {
  description = "Whether to enable encryption at rest"
  type        = bool
  default     = true
}

variable "encrypt_at_rest_kms_key_arn" {
  description = "KMS key ARN for encryption at rest"
  type        = string
  default     = null
}

variable "node_to_node_encryption_enabled" {
  description = "Whether node-to-node encryption is enabled"
  type        = bool
  default     = true
}

variable "vpc_options" {
  description = "VPC options for the OpenSearch domain"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "advanced_options" {
  description = "Key-value map of advanced options"
  type        = map(string)
  default     = {}
}

variable "access_policies" {
  description = "IAM policy document for domain access"
  type        = string
  default     = null
}

variable "log_publishing_options" {
  description = "Configuration block for publishing slow and application logs to CloudWatch Logs"
  type = list(object({
    log_type                 = string
    cloudwatch_log_group_arn = string
  }))
  default = []
}

variable "auto_tune_options" {
  description = "Configuration block for Auto-Tune options"
  type = object({
    desired_state       = string
    rollback_on_disable = optional(string)
    maintenance_schedule = optional(list(object({
      start_at = string
      duration = object({
        value = number
        unit  = string
      })
      cron_expression_for_recurrence = string
    })))
  })
  default = null
}

variable "advanced_security_options" {
  description = "Configuration block for fine-grained access control"
  type = object({
    enabled                        = bool
    internal_user_database_enabled = optional(bool)
    master_user_options = optional(object({
      master_user_arn      = optional(string)
      master_user_name     = optional(string)
      master_user_password = optional(string)
    }))
  })
  default = null
}

variable "cognito_options" {
  description = "Configuration block for Cognito authentication"
  type = object({
    enabled          = bool
    user_pool_id     = string
    identity_pool_id = string
    role_arn         = string
  })
  default = null
}

variable "domain_endpoint_options" {
  description = "Configuration block for domain endpoint options"
  type = object({
    enforce_https                   = bool
    tls_security_policy             = string
    custom_endpoint_enabled         = optional(bool)
    custom_endpoint                 = optional(string)
    custom_endpoint_certificate_arn = optional(string)
  })
  default = {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
}

variable "snapshot_options" {
  description = "Configuration block for snapshot options"
  type = object({
    automated_snapshot_start_hour = number
  })
  default = {
    automated_snapshot_start_hour = 0
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, production), merged into resource tags as Environment"
  type        = string
  default     = ""
}
