variable "lb_name" {
  type        = string
  description = "Name of LB"
}

variable "type_lb" {
  type        = string
  description = "Type of LB, possible values are application or network"
}

variable "subnets" {
  type    = list(string)
  default = "list of subnets"
}

variable "security_groups" {
  type    = list(string)
  default = "list of security group"
}

variable "is_internal" {
  type    = bool
  default = "If the lb is internal = true else false"
}

variable "ssl_policy" {
  type    = "string"
  default = "TYpe of policy to ssl"
}

variable "acm_lb_corp" {
  type        = "string"
  description = "arn to acm"
}

variable "vpc_id" {
  description = "VPC id where the lb will be deployed"
  type        = "string"
}

variable "sg_alb_name" {
  type        = "string"
  description = "name of SG to be linked to lb"
}

variable "sg_alb_description" {
  type        = "string"
  description = "Info about SG"
}

variable "sg_alb_tags" {
  type        = "map"
  description = "Information about the SG"
}

variable "i_description" {
  type        = "string"
  description = "description of IP ingress"
}

variable "i_ip_range" {
  type        = "string"
  description = "Range of IPs"
}

variable "e_ip_range" {
  type        = "string"
  description = "Range of IPs"
}
