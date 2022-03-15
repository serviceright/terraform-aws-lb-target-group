[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-lb-target-group)

[![Build Status](https://github.com/mineiros-io/terraform-aws-lb-target-group/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-aws-lb-target-group/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lb-target-group.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-lb-target-group/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-lb-target-group

A [Terraform] module to create and manage an
[Amazon Load Balancer Target Group](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html)
on [Amazon Web Services (AWS)][aws].

**_This module supports Terraform version 1
and is compatible with the Terraform AWS Provider version 3.47._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation](#aws-documentation)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources:

- `aws_lb_target_group`

## Getting Started

Most common usage of the module:

```hcl
module "terraform-aws-lb-target-group" {
  source = "git@github.com:mineiros-io/terraform-aws-lb-target-group.git?ref=v0.0.1"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`name_prefix`**](#var-name_prefix): *(Optional `string`)*<a name="var-name_prefix"></a>

  Creates a unique name beginning with the specified prefix. Conflicts
  with `name`. Cannot be longer than 6 characters. Forces new resource.

- [**`name`**](#var-name): *(Optional `string`)*<a name="var-name"></a>

  Name of the target group. If omitted, Terraform will assign a random,
  unique name. Forces new resource.

- [**`target_type`**](#var-target_type): *(Optional `string`)*<a name="var-target_type"></a>

  Type of target that you must specify when registering targets with
  this target group. The possible values are `instance` (targets are
  specified by instance ID) or `ip` (targets are specified by IP
  address) or `lambda` (targets are specified by lambda arn). Note that
  you can't specify targets for a target group using both instance IDs
  and IP addresses. If the target type is `ip`, specify IP addresses
  from the subnets of the virtual private cloud (VPC) for the target
  group. You can't specify publicly routable IP addresses.

- [**`port`**](#var-port): *(Optional `number`)*<a name="var-port"></a>

  Port on which targets receive traffic, unless overridden when
  registering a specific target. Required when `target_type` is
  `instance` or `ip`. Does not apply when `target_type` is `lambda`.

- [**`protocol`**](#var-protocol): *(Optional `string`)*<a name="var-protocol"></a>

  Protocol to use for routing traffic to the targets. Should be one of
  `GENEVE`, `HTTP`, `HTTPS`, `TCP`, `TCP_UDP`, `TLS`, or `UDP`.
  Required when `target_type` is instance, `ip` or `alb`. Does not apply
  when `target_type` is `lambda`.

- [**`protocol_version`**](#var-protocol_version): *(Optional `string`)*<a name="var-protocol_version"></a>

  Only applicable when protocol is `HTTP` or `HTTPS`. The protocol
  version. Specify `GRPC` to send requests to targets using gRPC.
  Specify `HTTP2` to send requests to targets using `HTTP/2`. The
  default is HTTP1, which sends requests to targets using HTTP/1.1

  Default is `"HTTP1"`.

- [**`preserve_client_ip`**](#var-preserve_client_ip): *(Optional `bool`)*<a name="var-preserve_client_ip"></a>

  Whether client IP preservation is enabled.

- [**`lambda_multi_value_headers_enabled`**](#var-lambda_multi_value_headers_enabled): *(Optional `bool`)*<a name="var-lambda_multi_value_headers_enabled"></a>

  Whether the request and response headers exchanged between the load
  balancer and the Lambda function include arrays of values or strings.
  Only applies when `target_type` is `lambda`.

- [**`load_balancing_algorithm_type`**](#var-load_balancing_algorithm_type): *(Optional `bool`)*<a name="var-load_balancing_algorithm_type"></a>

  Determines how the load balancer selects targets when routing
  requests. Only applicable for Application Load Balancer Target Groups.
  The value is `round_robin` or `least_outstanding_requests`.

- [**`health_check`**](#var-health_check): *(Optional `object(health_check)`)*<a name="var-health_check"></a>

  Determines how the load balancer selects targets when routing
  requests. Only applicable for Application Load Balancer Target Groups.
  The value is `round_robin` or `least_outstanding_requests`.

  The `health_check` object accepts the following attributes:

  - [**`enabled`**](#attr-health_check-enabled): *(Optional `bool`)*<a name="attr-health_check-enabled"></a>

    Whether health checks are enabled.

    Default is `true`.

  - [**`healthy_threshold`**](#attr-health_check-healthy_threshold): *(Optional `number`)*<a name="attr-health_check-healthy_threshold"></a>

    Number of consecutive health checks successes required before
    considering an unhealthy target healthy.

  - [**`interval`**](#attr-health_check-interval): *(Optional `number`)*<a name="attr-health_check-interval"></a>

    Approximate amount of time, in seconds, between health checks of an
    individual target. Minimum value `5` seconds, Maximum value `300`
    seconds. For lambda target groups, it needs to be greater as the
    timeout of the underlying lambda.

  - [**`matcher`**](#attr-health_check-matcher): *(Optional `string`)*<a name="attr-health_check-matcher"></a>

    Response codes to use when checking for a healthy responses from a
    target. You can specify multiple values (for example, `"200,202"`
    for HTTP(s) or `"0,12"` for GRPC) or a range of values (for example,
    `"200-299"` or `"0-99"`). Required for HTTP/HTTPS/GRPC ALB. Only
    applies to Application Load Balancers (i.e., HTTP/HTTPS/GRPC) not
    Network Load Balancers (i.e., TCP).

  - [**`path`**](#attr-health_check-path): *(Optional `string`)*<a name="attr-health_check-path"></a>

    Destination for the health check request. Required for
    HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS.

  - [**`port`**](#attr-health_check-port): *(Optional `string`)*<a name="attr-health_check-port"></a>

    Port to use to connect with the target. Valid values are either
    ports `1`-`65535`, or `traffic-port`.

  - [**`protocol`**](#attr-health_check-protocol): *(Optional `string`)*<a name="attr-health_check-protocol"></a>

    Protocol to use to connect with the target.

  - [**`timeout`**](#attr-health_check-timeout): *(Optional `number`)*<a name="attr-health_check-timeout"></a>

    Amount of time, in seconds, during which no response means a failed
    health check. For Application Load Balancers, the range is `2` to
    `120` seconds, and the default is `5` seconds for the instance
    target type and `30` seconds for the lambda target type. For
    Network Load Balancers, you cannot set a custom value, and the
    default is `10` seconds for TCP and HTTPS health checks and `6`
    seconds for HTTP health checks.

  - [**`unhealthy_threshold`**](#attr-health_check-unhealthy_threshold): *(Optional `number`)*<a name="attr-health_check-unhealthy_threshold"></a>

    Number of consecutive health check failures required before
    considering the target unhealthy. For Network Load Balancers, this
    value must be the same as the `healthy_threshold`.

- [**`stickiness`**](#var-stickiness): *(Optional `object(stickiness)`)*<a name="var-stickiness"></a>

  Stickiness configuration block.

  The `stickiness` object accepts the following attributes:

  - [**`enabled`**](#attr-stickiness-enabled): *(Optional `bool`)*<a name="attr-stickiness-enabled"></a>

    Boolean to enable / disable stickiness.

    Default is `true`.

  - [**`type`**](#attr-stickiness-type): *(Optional `string`)*<a name="attr-stickiness-type"></a>

    The type of sticky sessions. The only current possible values are
    `lb_cookie`, `app_cookie` for ALBs, and `source_ip` for NLBs.

  - [**`cookie_name`**](#attr-stickiness-cookie_name): *(Optional `string`)*<a name="attr-stickiness-cookie_name"></a>

    Name of the application based cookie. AWSALB, AWSALBAPP, and
    AWSALBTG prefixes are reserved and cannot be used. Only needed when
    type is `app_cookie`.

  - [**`cookie_duration`**](#attr-stickiness-cookie_duration): *(**Required** `number`)*<a name="attr-stickiness-cookie_duration"></a>

    Only used when the type is `lb_cookie`. The time period, in seconds,
    during which requests from a client should be routed to the same
    target. After this time period expires, the load balancer-generated
    cookie is considered stale. The range is `1` second to 1 week
    (`604800` seconds).

- [**`vpc_id`**](#var-vpc_id): *(Optional `string`)*<a name="var-vpc_id"></a>

  Name of the target group. If omitted, Terraform will assign a random,
  unique name. Forces new resource.

- [**`deregistration_delay`**](#var-deregistration_delay): *(Optional `number`)*<a name="var-deregistration_delay"></a>

  Amount time for Elastic Load Balancing to wait before changing the
  state of a deregistering target from draining to unused. The range is
  `0`-`3600` seconds.

  Default is `300`.

- [**`tags`**](#var-tags): *(Optional `map(string)`)*<a name="var-tags"></a>

  A map of tags to apply to the created load balancer target group.

  Default is `{}`.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that accept tags.
  Tags defined with `module_tags` can be overwritten by resource-specific tags.

  Default is `{}`.

  Example:

  ```hcl
  module_tags = {
    environment = "staging"
    team        = "platform"
  }
  ```

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`lb_target_group`**](#output-lb_target_group): *(`object(lb_target_group)`)*<a name="output-lb_target_group"></a>

  All outputs of the created `aws_lb_target_group` resource.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`module_tags`**](#output-module_tags): *(`map(string)`)*<a name="output-module_tags"></a>

  The map of tags that are being applied to all created resources that accept tags.

## External Documentation

### AWS Documentation

- Application Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
- Network Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-lb-target-group
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-aws-lb-target-group/issues
[license]: https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-aws-lb-target-group/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-aws-lb-target-group/blob/main/CONTRIBUTING.md
