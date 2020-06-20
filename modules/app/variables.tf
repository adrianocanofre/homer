###### Common ######
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "Application Name"
  default     = "Homer"
}

variable "region" {
  description = "Region to create the infrastructure"
  default     = "us-east-1"
}

variable "key_pair" {
  description = "The key name of the Key Pair to use for the instance"
  default     = "terraform_aws"
}

variable "workspace" {
  default = ""
}

###### Application ######
variable "create_lb" {
  default = true
}

variable "app_lb_arn" {
  default = ""
}

variable "app_lb_listener_arn" {
  default = null
}

variable "app_lb_target_arn" {
  default = ""
}

variable "lb_condition_path"{
  default = null
}

variable "lb_type" {
  description = "The type of load balancer to create(application|network)"
  default     = "application"
}

variable "asg_min_size" {
  default = 1
}

variable "asg_max_size" {
  default = 2
}

variable "asg_desired_capacity" {
  default = 1
}

variable "http_protocol" {
  description = "Protocol HTTP"
  default     ="HTTP"
}

variable "health_check_path" {
  description = "Health check use in target"
  default     = "/api/healthcheck"
}

variable "health_check_healthy_threshold" {
  description = ""
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = ""
  default     = 10
}

variable "health_check_timeout" {
  description = ""
  default     = 5
}

variable "health_check_interval" {
  description = ""
  default     = 10
}

variable "health_check_port" {
  description = ""
  default     = 80
}

variable "user_data" {
  default = ""
}

variable "ec2_type"{
  default = "t2.micro"
}

variable "public_subnets" {
  default = ""
}

variable "private_subnets" {
  default = ""
}

variable "vpc_id" {
  default = null
}

variable "image_mutability" {
  default = "MUTABLE"
}

variable "scheduled_action_name" {
  default = null
}

variable "scheduled_min_size" {
  default = null
}

variable "scheduled_max_size" {
  default = null
}

variable "scheduled_desired_capacity" {
  default = null
}

variable "scheduled_start_time" {
  default = null
}

variable "scheduled_end_time" {
  default = null
}

variable "scheduled_recurrence_down" {
  default = null
}

variable "scheduled_recurrence_up" {
  default = null
}

variable "scaling_adjustment_type"{
  default = "ChangeInCapacity"
}
variable "scaling_cooldown" {

  default = "300"
}

variable "scaling_adjustment_up" {
  default = "1"
}

variable "scaling_adjustment_down" {
  default = "-1"
}

variable "scaling_policy_type" {
  default = "SimpleScaling"
}

variable "metric_namespace"{
  default = "AWS/EC2"
}

variable "metric_name" {
  default = "CPUUtilization"
}

variable "metric_period" {
  default = "300"
}

variable "metric_statistic" {
  default = "Average"
}

variable "metric_threshold_high" {
  default = "80"
}

variable "metric_threshold_low" {
  default = "30"
}

variable "metric_evaluation_periods" {
  default = "5"
}

variable "metric_comparison_operator_low" {
  default = "LessThanOrEqualToThreshold"
}

variable "metric_comparison_operator_high" {
  default = "GreaterThanOrEqualToThreshold"
}
### S3 ###
variable "bucket_name_env" {
  description = "Application Name"
  default     = "homer"
}

variable "bucket_name" {
  default = ""
}
variable "version_enable" {
  default = true
}

variable "create_bucket" {
  default = false
}

### SG ###
variable "all_cidr" {
  description = ""
  default     = "0.0.0.0/0"
}

variable "sg_by_user_name" {
  default = null
}

variable "sg_by_user_description" {
  default = "[Default] SG the application"
}

variable "e_rule" {
  default = null
}

variable "sg_app" {
  default = null
}

variable "e_port" {
  description = ""
  default     = 80
}

variable "e_protocol" {
  description = ""
  default     = "tcp"
}

variable "http_port" {
  description = ""
  default     = 80
}
