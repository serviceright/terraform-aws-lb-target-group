header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-lb-target-group"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-lb-target-group/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-lb-target-group/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lb-target-group.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-lb-target-group/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-lb-target-group"
  toc     = true
  content = <<-END
    A [Terraform] module to create and manage an
    [Amazon Load Balancer Target Group](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html)
    on [Amazon Web Services (AWS)][aws].

    **_This module supports Terraform version 1
    and is compatible with the Terraform AWS Provider version 3.47._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources:

      - `aws_lb_target_group`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-aws-lb-target-group" {
        source = "git@github.com:mineiros-io/terraform-aws-lb-target-group.git?ref=v0.0.1"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name_prefix" {
        type        = string
        description = <<-END
          Creates a unique name beginning with the specified prefix. Conflicts
          with `name`. Cannot be longer than 6 characters. Forces new resource.
        END
      }

      variable "name" {
        type        = string
        description = <<-END
          Name of the target group. If omitted, Terraform will assign a random,
          unique name. Forces new resource.
        END
      }

      variable "target_type" {
        type        = string
        description = <<-END
          Type of target that you must specify when registering targets with
          this target group. The possible values are `instance` (targets are
          specified by instance ID) or `ip` (targets are specified by IP
          address) or `lambda` (targets are specified by lambda arn). Note that
          you can't specify targets for a target group using both instance IDs
          and IP addresses. If the target type is `ip`, specify IP addresses
          from the subnets of the virtual private cloud (VPC) for the target
          group. You can't specify publicly routable IP addresses.
        END
      }

      variable "port" {
        type        = number
        description = <<-END
          Port on which targets receive traffic, unless overridden when
          registering a specific target. Required when `target_type` is
          `instance` or `ip`. Does not apply when `target_type` is `lambda`.
        END
      }

      variable "protocol_version" {
        type        = string
        default     = "HTTP1"
        description = <<-END
          Only applicable when protocol is `HTTP` or `HTTPS`. The protocol
          version. Specify `GRPC` to send requests to targets using gRPC.
          Specify `HTTP2` to send requests to targets using `HTTP/2`. The
          default is HTTP1, which sends requests to targets using HTTP/1.1
        END
      }

      variable "preserve_client_ip" {
        type        = bool
        description = <<-END
          Whether client IP preservation is enabled.
        END
      }

      variable "lambda_multi_value_headers_enabled" {
        type        = bool
        description = <<-END
          Whether the request and response headers exchanged between the load
          balancer and the Lambda function include arrays of values or strings.
          Only applies when `target_type` is `lambda`.
        END
      }

      variable "load_balancing_algorithm_type" {
        type        = bool
        description = <<-END
          Determines how the load balancer selects targets when routing
          requests. Only applicable for Application Load Balancer Target Groups.
          The value is `round_robin` or `least_outstanding_requests`.
        END
      }

      variable "health_check" {
        type        = object(health_check)
        description = <<-END
          Determines how the load balancer selects targets when routing
          requests. Only applicable for Application Load Balancer Target Groups.
          The value is `round_robin` or `least_outstanding_requests`.
        END

        attribute "enabled" {
          type        = bool
          default     = true
          description = <<-END
            Whether health checks are enabled.
          END
        }

        attribute "healthy_threshold" {
          type        = number
          description = <<-END
            Number of consecutive health checks successes required before
            considering an unhealthy target healthy.
          END
        }

        attribute "interval" {
          type        = number
          description = <<-END
            Approximate amount of time, in seconds, between health checks of an
            individual target. Minimum value `5` seconds, Maximum value `300`
            seconds. For lambda target groups, it needs to be greater as the
            timeout of the underlying lambda. 
          END
        }

        attribute "matcher" {
          type        = string
          description = <<-END
            Response codes to use when checking for a healthy responses from a
            target. You can specify multiple values (for example, `"200,202"`
            for HTTP(s) or `"0,12"` for GRPC) or a range of values (for example,
            `"200-299"` or `"0-99"`). Required for HTTP/HTTPS/GRPC ALB. Only
            applies to Application Load Balancers (i.e., HTTP/HTTPS/GRPC) not
            Network Load Balancers (i.e., TCP).
          END
        }

        attribute "path" {
          type        = string
          description = <<-END
            Destination for the health check request. Required for
            HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS.
          END
        }
        attribute "port" {
          type        = string
          description = <<-END
            Port to use to connect with the target. Valid values are either
            ports `1`-`65535`, or `traffic-port`.
          END
        }

        attribute "protocol" {
          type        = string
          description = <<-END
            Protocol to use to connect with the target. 
          END
        }

        attribute "timeout" {
          type        = number
          description = <<-END
            Amount of time, in seconds, during which no response means a failed
            health check. For Application Load Balancers, the range is `2` to
            `120` seconds, and the default is `5` seconds for the instance
            target type and `30` seconds for the lambda target type. For
            Network Load Balancers, you cannot set a custom value, and the
            default is `10` seconds for TCP and HTTPS health checks and `6`
            seconds for HTTP health checks.
          END
        }

        attribute "unhealthy_threshold" {
          type        = number
          description = <<-END
            Number of consecutive health check failures required before
            considering the target unhealthy. For Network Load Balancers, this
            value must be the same as the `healthy_threshold`. 
          END
        }
      }

      variable "stickiness" {
        type        = object(stickiness)
        description = <<-END
          Stickiness configuration block. 
        END

        attribute "enabled" {
          type        = bool
          default     = true
          description = <<-END
            Boolean to enable / disable stickiness.
          END
        }

        attribute "type" {
          type        = string
          description = <<-END
            The type of sticky sessions. The only current possible values are
            `lb_cookie`, `app_cookie` for ALBs, and `source_ip` for NLBs.
          END
        }

        attribute "cookie_name" {
          type        = string
          description = <<-END
            Name of the application based cookie. AWSALB, AWSALBAPP, and
            AWSALBTG prefixes are reserved and cannot be used. Only needed when
            type is `app_cookie`.
          END
        }

        attribute "cookie_duration" {
          required    = true
          type        = number
          description = <<-END
            Only used when the type is `lb_cookie`. The time period, in seconds,
            during which requests from a client should be routed to the same
            target. After this time period expires, the load balancer-generated
            cookie is considered stale. The range is `1` second to 1 week
            (`604800` seconds).
          END
        }
      }

      variable "vpc_id" {
        type        = string
        description = <<-END
          Name of the target group. If omitted, Terraform will assign a random,
          unique name. Forces new resource.
        END
      }

      variable "deregistration_delay" {
        type        = number
        default     = 300
        description = <<-END
          Amount time for Elastic Load Balancing to wait before changing the
          state of a deregistering target from draining to unused. The range is
          `0`-`3600` seconds.
        END
      }

      variable "tags" {
        type        = map(string)
        default     = {}
        description = <<-END
          A map of tags to apply to the created load balancer target group.
        END
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_tags" {
        type           = map(string)
        default        = {}
        description    = <<-END
          A map of tags that will be applied to all created resources that accept tags.
          Tags defined with `module_tags` can be overwritten by resource-specific tags.
        END
        readme_example = <<-END
          module_tags = {
            environment = "staging"
            team        = "platform"
          }
        END
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "lb_target_group" {
      type        = object(lb_target_group)
      description = <<-END
        All outputs of the created `aws_lb_target_group` resource.
      END
    }

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }

    output "module_tags" {
      type        = map(string)
      description = <<-END
        The map of tags that are being applied to all created resources that accept tags.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation"
      content = <<-END
        - Application Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
        - Network Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-lb-target-group"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-aws-lb-target-group/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-aws-lb-target-group/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/CONTRIBUTING.md"
  }
}
