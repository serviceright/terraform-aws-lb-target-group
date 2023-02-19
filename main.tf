locals {
  name                               = var.name
  name_prefix                        = var.name == null ? var.name_prefix : null
  port                               = var.target_type != "lambda" ? var.port : null
  protocol                           = var.target_type != "lambda" ? var.protocol : null
  protocol_version                   = can(regex("^HTTPS?$", var.protocol)) ? var.protocol_version : null
  lambda_multi_value_headers_enabled = var.target_type == "lambda" ? var.lambda_multi_value_headers_enabled : null
  default_preserve_client_ip         = var.protocol != null ? (contains(["TCP", "TLS"], var.protocol) ? false : contains(["UDP", "TCP_UDP"], var.protocol) ? true : null) : null
  preserve_client_ip                 = var.preserve_client_ip != null ? var.preserve_client_ip : local.default_preserve_client_ip
  vpc_id                             = can(regex("^(instance|ip)$", var.target_type)) ? var.vpc_id : null
}

resource "aws_lb_target_group" "target_group" {
  count = var.module_enabled ? 1 : 0

  name             = local.name
  name_prefix      = local.name_prefix
  port             = local.port
  protocol         = local.protocol
  protocol_version = local.protocol_version
  target_type      = var.target_type

  vpc_id = local.vpc_id

  deregistration_delay               = var.deregistration_delay
  lambda_multi_value_headers_enabled = local.lambda_multi_value_headers_enabled
  load_balancing_algorithm_type      = var.load_balancing_algorithm_type
  preserve_client_ip                 = local.preserve_client_ip

  dynamic "health_check" {
    for_each = var.health_check != null ? [var.health_check] : []

    content {
      enabled = try(health_check.value.enabled, true)

      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      interval            = try(health_check.value.interval, null)
      matcher             = try(health_check.value.matcher, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      protocol            = try(health_check.value.protocol, null)
      timeout             = try(health_check.value.timeout, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
    }
  }

  dynamic "stickiness" {
    for_each = var.stickiness != null ? [var.stickiness] : []

    content {
      enabled = try(stickiness.value.enabled, true)

      type            = stickiness.value.type
      cookie_name     = try(stickiness.value.cookie_name, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
    }
  }

  tags = merge(var.module_tags, var.tags)

  depends_on = [var.module_depends_on]
}

# create the attachment dynamically
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  for_each = var.target_groups
  target_group_arn = each.value.target_group_arn
  target_id        = each.value.target_id
}