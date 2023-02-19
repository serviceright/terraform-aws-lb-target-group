# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

variable "name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name. Cannot be longer than 6 characters."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix != null ? length(var.name_prefix) <= 6 : true
    error_message = "The 'name_prefix' can have a max length of 6 chars."
  }
}

variable "name" {
  description = "(Optional, Forces new resource) Name of the target group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "target_type" {
  description = "(Optional, Forces new resource) Type of target that you must specify when registering targets with this target group. The possible values are 'instance' (targets are specified by instance ID) or 'ip' (targets are specified by IP address) or 'lambda' (targets are specified by lambda arn). Note that you can't specify targets for a target group using both instance IDs and IP addresses. If the target type is 'ip', specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group. You can't specify publicly routable IP addresses."
  type        = string
  default     = null

  validation {
    condition     = var.target_type == null ? true : contains(["instance", "ip", "lambda"], var.target_type)
    error_message = "The possible values for the 'target_type' variable are 'instance' (targets are specified by instance ID) or 'ip' (targets are specified by IP address) or 'lambda' (targets are specified by lambda arn)."
  }
}

variable "port" {
  description = "(May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when 'target_type' is 'instance' or 'ip'. Does not apply when 'target_type' is 'lambda'."
  type        = number
  default     = null
}

variable "protocol" {
  description = "(May be required, Forces new resource) Protocol to use for routing traffic to the targets. Should be one of 'GENEVE', 'HTTP', 'HTTPS', 'TCP', 'TCP_UDP', 'TLS', or 'UDP'. Required when 'target_type' is instance or ip. Does not apply when 'target_type' is 'lambda'."
  type        = string
  default     = null
}

variable "protocol_version" {
  description = "(Optional, Forces new resource) Only applicable when protocol is 'HTTP' or 'HTTPS'. The protocol version. Specify 'GRPC' to send requests to targets using gRPC. Specify 'HTTP2' to send requests to targets using 'HTTP/2'. The default is HTTP1, which sends requests to targets using HTTP/1.1"
  type        = string
  default     = "HTTP1"
}

variable "preserve_client_ip" {
  description = "(Optional) Whether client IP preservation is enabled."
  type        = bool
  default     = null
}

variable "lambda_multi_value_headers_enabled" {
  description = "(Optional) Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when 'target_type' is 'lambda'."
  type        = bool
  default     = null
}

variable "load_balancing_algorithm_type" {
  description = "(Optional) Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is 'round_robin' or 'least_outstanding_requests'."
  type        = bool
  default     = null
}

variable "health_check" {
  description = "(Optional) Health Check configuration block"
  type        = any
  # type = object({
  #   # (Optional) Whether health checks are enabled. Defaults to true.
  #   enabled = optional(bool)
  #   # (Optional) Number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 3.
  #   healthy_threshold = optional(bool)
  #   # (Optional) Approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. For lambda target groups, it needs to be greater as the timeout of the underlying lambda. Default 30 seconds.
  #   interval = optional(number)
  #   # (May be required) Response codes to use when checking for a healthy responses from a target. You can specify multiple values (for example, "200,202" for HTTP(s) or "0,12" for GRPC) or a range of values (for example, "200-299" or "0-99"). Required for HTTP/HTTPS/GRPC ALB. Only applies to Application Load Balancers (i.e., HTTP/HTTPS/GRPC) not Network Load Balancers (i.e., TCP).
  #   matcher = optional(string)
  #   # (May be required) Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS.
  #   path = optional(string)
  #   # (Optional) Port to use to connect with the target. Valid values are either ports 1-65535, or traffic-port. Defaults to traffic-port.
  #   port = optional(any)
  #   # (Optional) Protocol to use to connect with the target. Defaults to HTTP. Not applicable when target_type is lambda.
  #   protocol = optional(string)
  #   # (Optional) Amount of time, in seconds, during which no response means a failed health check. For Application Load Balancers, the range is 2 to 120 seconds, and the default is 5 seconds for the instance target type and 30 seconds for the lambda target type. For Network Load Balancers, you cannot set a custom value, and the default is 10 seconds for TCP and HTTPS health checks and 6 seconds for HTTP health checks
  #   timeout = optional(number)
  #   # (Optional) Number of consecutive health check failures required before considering the target unhealthy. For Network Load Balancers, this value must be the same as the healthy_threshold. Defaults to 3.
  #   unhealthy_threshold = optional(number)
  # })
  default = null
}

variable "stickiness" {
  description = "(Optional) Stickiness configuration block. For details please see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#stickiness."
  # type = optional(object({
  #   #  (Required) Time period, in seconds, during which requests from a client should be routed to the same target group. The range is 1-604800 seconds (7 days)
  #   duration = number
  #   # (Optional) Whether target group stickiness is enabled
  #   enabled = optional(bool)
  #   # (Optional) Name of the application based cookie. AWSALB, AWSALBAPP, and AWSALBTG prefixes are reserved and cannot be used. Only needed when type is app_cookie.
  #   cookie_name      = optional(string)
  #   # (Optional) Only used when the type is lb_cookie. The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds).
  #   cookie_duraction = optional(number)
  # }))
  type    = any
  default = null
}

variable "vpc_id" {
  description = "(Optional, Forces new resource) Identifier of the VPC in which to create the target group. Required when 'target_type' is 'instance', 'ip' or 'alb'. Does not apply when 'target_type' is 'lambda'."
  type        = string
  default     = null
}

variable "deregistration_delay" {
  type        = number
  description = "(Optional) Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds."
  default     = 300

  validation {
    condition     = var.deregistration_delay >= 0 && var.deregistration_delay <= 3600
    error_message = "The value of the 'deregistration_delay' variable needs to be a number in the range 0-3600 (seconds)."
  }
}

variable "tags" {
  description = "(Optional) A map of tags to apply to the created load balancer target group. Default is {}."
  type        = map(string)
  default     = {}
}

variable "target_groups" {
  description = "The target groups we need to use"
  default = []
  type = list(object({
    target_id = string
  }))
}

# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is []."
  default     = []
}

variable "module_tags" {
  description = "(Optional) A map of default tags to apply to all resources created which support tags. Default is {}."
  type        = map(string)
  default     = {}
}
