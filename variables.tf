variable "app_name" {
  description = "Project name."
  type        = string
  default     = "homer"
}

variable "number_ec2" {
  description = "Number of ec2."
  type        = number
  default     = 2
}

variable "ec2_type" {
  description = "Instance type(t3.medium, t3.xlarge, etc)"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The key name that should be used for the instance."
  type        = string
  default     = "homer"
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
  default     = null
}

variable "lb_type" {
  description = "Tipo de LB."
  type        = string
  default     = "application"
}

variable "lb_internal" {
  description = "True or false"
  type        = bool
  default     = false
}

variable "http_port" {
  description = "Port on which the load balancer is listening."
  type        = number
  default     = 80
}

variable "http_protocol" {
  description = "Protocol for connections from clients to the load balancer."
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.http_protocol)
    error_message = "The values are HTTP and HTTPS."
  }
}

variable "health_check" {
  description = "A list of maps containing key/value pair."
  type        = any
  default = {
    interval            = 30
    path                = "/"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 2
    protocol            = "HTTP"
  }
}

variable "vpc_name" {
  description = "VPC name."
  type        = string
  default     = "homer-dev"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "subnet_public_name" {
  description = "Subnet public name."
  type        = string
  default     = "homer-public-dev"
}

variable "subnet_private_name" {
  description = "Subnet private name."
  type        = string
  default     = "homer-private-dev"
}

variable "asg_min_size" {
  description = "The minimum size of the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size of the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "asg_desired_capacity" {
  description = " The number of Amazon EC2 instances that should be running in the group."
  type        = number
  default     = 1
}
