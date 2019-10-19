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
  description = "Nome do SG"
}

variable "sg_alb_description" {
  type        = "string"
  description = "Descrição do SG"
}

variable "sg_alb_tags" {
  type        = "map"
  description = "Tags para o SG do ALB corp"
}

variable "ingress_description" {
  type        = "string"
  description = "Descrição do SG"
}

variable "i_ip_range" {
  type        = "string"
  description = "Range de IPs do Ingress"
}

variable "e_ip_range" {
  type        = "string"
  description = "Range de IPs do Egress"
}
