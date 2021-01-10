###### Common ######
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "Application Name"
  type        = string
  default     = "Homer"
}

variable "region" {
  description = "Region to create the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "key_pair" {
  description = "The key name of the Key Pair to use for the instance"
  type        = string
  default     = "terraform_aws"
}

variable "workspace" {
  description = ""
  type        = string
  default     = null
}

###### Application ######
variable "create_lb" {
  description = "Whether to create a load balance"
  type        = bool
  default     = true
}

# variable "app_lb_arn" {
#   description = ""
#   type        = bool
#   default     = null
# }

variable "app_lb_listener_arn" {
  description = "The ARN of the listener to which to attach the rule."
  type        = string
  default     = null
}
#
# variable "app_lb_target_arn" {
#   description = ""
#   type        = string
#   default     = ""
# }

variable "lb_condition_path" {
  description = ""
  type        = string
  default     = null
}

variable "lb_type" {
  description = "The type of load balancer to create(application|network)"
  type        = string
  default     = "application"
}

variable "asg_min_size" {
  description = "The minimum size for the Auto Scaling group."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size for the Auto Scaling group."
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "The number of EC2 instances that should be running in the group."
  type        = number
  default     = 1
}

variable "http_protocol" {
  description = "Protocol HTTP"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check use in target"
  type        = string
  default     = "/api/healthcheck"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy."
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy ."
  type        = number
  default     = 10
}

variable "health_check_timeout" {
  description = " The amount of time, in seconds, during which no response means a failed health check."
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target( Minimum value 5 seconds, Maximum value 300 seconds)."
  type        = number
  default     = 10
}

variable "health_check_port" {
  description = "The destination for the health check request."
  type        = number
  default     = 80
}

variable "user_data" {
  description = ""
  type        = string
  default     = ""
}

variable "ec2_type" {
  description = "The type of instance to start."
  type        = string
  default     = "t2.micro"
}

variable "public_subnets" {
  description = "A list of public subnet IDs to attach to the ELB."
  type        = list(string)
  default     = null
}

variable "private_subnets" {
  description = "A list of private subnet IDs to attach to the ELB."
  type        = list(string)
  default     = null
}

variable "vpc_id" {
  description = "The vpc ID."
  type        = string
  default     = null
}

variable "image_mutability" {
  description = "The tag mutability setting for the repository."
  type        = string
  default     = "MUTABLE"
}

variable "scheduled_action_name" {
  description = "The name or Amazon Resource Name (ARN) of the Auto Scaling group."
  type        = string
  default     = null
}

variable "scheduled_min_size" {
  description = "The minimum size for the Auto Scaling group."
  type        = string
  default     = null
}

variable "scheduled_max_size" {
  description = "The minimum size for the Auto Scaling group."
  type        = string
  default     = null
}

variable "scheduled_desired_capacity" {
  description = "The number of EC2 instances that should be running in the group."
  type        = string
  default     = null
}

variable "scheduled_start_time" {
  description = "The time for this action to start, in 'YYYY-MM-DDThh:mm:ssZ' format in UTC/GMT only."
  type        = string
  default     = null
}

variable "scheduled_end_time" {
  description = "The time for this action to finish, in 'YYYY-MM-DDThh:mm:ssZ' format in UTC/GMT only."
  type        = string
  default     = null
}

variable "scheduled_recurrence_down" {
  description = " The time when recurring future actions will start."
  type        = string
  default     = null
}

variable "scheduled_recurrence_up" {
  description = " The time when recurring future actions will start.  "
  type        = string
  default     = null
}

variable "scaling_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity."
  type        = string
  default     = "ChangeInCapacity"
}
variable "scaling_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  type        = number
  default     = 300
}

variable "scaling_adjustment_up" {
  description = "The number of instances by which to scale."
  type        = number
  default     = 1
}

variable "scaling_adjustment_down" {
  description = "The number of instances by which to scale."
  type        = string
  default     = "-1"
}

variable "scaling_policy_type" {
  description = "The policy type."
  type        = string
  default     = "SimpleScaling"
}

variable "metric_namespace" {
  description = "The namespace for the alarm's associated metric."
  type        = string
  default     = "AWS/EC2"
}

variable "metric_name" {
  description = "The name for the alarm's associated metric."
  type        = string
  default     = "CPUUtilization"
}

variable "metric_period" {
  description = " The period in seconds over which the specified statistic is applied."
  type        = number
  default     = 300
}

variable "metric_statistic" {
  description = "The statistic to apply to the alarm's associated metric."
  type        = string
  default     = "Average"
}

variable "metric_threshold_high" {
  description = "The value against which the specified statistic is compared."
  type        = number
  default     = 80
}

variable "metric_threshold_low" {
  description = "The value against which the specified statistic is compared."
  type        = number
  default     = 30
}

variable "metric_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
  default     = 5
}

variable "metric_comparison_operator_low" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold."
  type        = string
  default     = "LessThanOrEqualToThreshold"
}

variable "metric_comparison_operator_high" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold."
  type        = string
  default     = "GreaterThanOrEqualToThreshold"
}

### S3 ###
variable "bucket_name_env" {
  description = "Application Name"
  type        = string
  default     = "homer"
}

variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
  default     = ""
}
variable "version_enable" {
  description = ""
  type        = bool
  default     = true
}

variable "create_bucket" {
  description = "Whether to create a bucket"
  type        = bool
  default     = false
}

### SG ###
variable "all_cidr" {
  description = "List of allowed CIDR blocks."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "sg_by_user_name" {
  default = null
}

variable "e_rule" {
  default = null
}

variable "sg_app" {
  description = "List of sg-id that allows communication."
  type        = list(string)
  default     = null
}

variable "e_port" {
  description = ""
  type        = number
  default     = 80
}

variable "e_protocol" {
  description = ""
  type        = string
  default     = "tcp"
}

variable "http_port" {
  description = ""
  type        = number
  default     = 80
}
