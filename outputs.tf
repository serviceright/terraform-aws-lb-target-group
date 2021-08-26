# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "lb_target_group" {
  description = "All outputs of the created 'aws_lb_target_group' resource."
  value       = try(aws_lb_target_group.target_group[0], {})
}

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}

output "module_tags" {
  description = "A map of tags that will be applied to all created resources that accept tags."
  value       = var.module_tags
}
