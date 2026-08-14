locals {
  tags = merge(
    var.tags,
    var.environment != "" ? { Environment = var.environment } : {},
  )
}

resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain_name
  engine_version = var.engine_version

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_enabled ? var.dedicated_master_type : null
    dedicated_master_count   = var.dedicated_master_enabled ? var.dedicated_master_count : null
    zone_awareness_enabled   = var.zone_awareness_enabled

    dynamic "zone_awareness_config" {
      for_each = var.zone_awareness_enabled ? [1] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_type = var.ebs_enabled ? var.volume_type : null
    volume_size = var.ebs_enabled ? var.volume_size : null
    iops        = var.ebs_enabled && contains(["io1", "io2"], var.volume_type) ? var.iops : null
    throughput  = var.ebs_enabled && var.volume_type == "gp3" ? var.throughput : null
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_at_rest_kms_key_arn
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  domain_endpoint_options {
    enforce_https                   = var.domain_endpoint_options.enforce_https
    tls_security_policy             = var.domain_endpoint_options.tls_security_policy
    custom_endpoint_enabled         = coalesce(var.domain_endpoint_options.custom_endpoint_enabled, false)
    custom_endpoint                 = var.domain_endpoint_options.custom_endpoint
    custom_endpoint_certificate_arn = var.domain_endpoint_options.custom_endpoint_certificate_arn
  }

  dynamic "vpc_options" {
    for_each = var.vpc_options != null ? [var.vpc_options] : []
    content {
      subnet_ids         = vpc_options.value.subnet_ids
      security_group_ids = vpc_options.value.security_group_ids
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.snapshot_options.automated_snapshot_start_hour
  }

  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options
    content {
      log_type                 = log_publishing_options.value.log_type
      cloudwatch_log_group_arn = log_publishing_options.value.cloudwatch_log_group_arn
      enabled                  = true
    }
  }

  dynamic "advanced_security_options" {
    for_each = var.advanced_security_options != null ? [var.advanced_security_options] : []
    content {
      enabled                        = advanced_security_options.value.enabled
      internal_user_database_enabled = coalesce(advanced_security_options.value.internal_user_database_enabled, false)

      dynamic "master_user_options" {
        for_each = advanced_security_options.value.master_user_options != null ? [advanced_security_options.value.master_user_options] : []
        content {
          master_user_arn      = master_user_options.value.master_user_arn
          master_user_name     = master_user_options.value.master_user_name
          master_user_password = master_user_options.value.master_user_password
        }
      }
    }
  }

  dynamic "cognito_options" {
    for_each = var.cognito_options != null ? [var.cognito_options] : []
    content {
      enabled          = cognito_options.value.enabled
      user_pool_id     = cognito_options.value.user_pool_id
      identity_pool_id = cognito_options.value.identity_pool_id
      role_arn         = cognito_options.value.role_arn
    }
  }

  dynamic "auto_tune_options" {
    for_each = var.auto_tune_options != null ? [var.auto_tune_options] : []
    content {
      desired_state       = auto_tune_options.value.desired_state
      rollback_on_disable = coalesce(auto_tune_options.value.rollback_on_disable, "NO_ROLLBACK")

      dynamic "maintenance_schedule" {
        for_each = coalesce(auto_tune_options.value.maintenance_schedule, [])
        content {
          start_at = maintenance_schedule.value.start_at
          duration {
            value = maintenance_schedule.value.duration.value
            unit  = maintenance_schedule.value.duration.unit
          }
          cron_expression_for_recurrence = maintenance_schedule.value.cron_expression_for_recurrence
        }
      }
    }
  }

  advanced_options = var.advanced_options
  access_policies  = var.access_policies

  tags = local.tags
}
