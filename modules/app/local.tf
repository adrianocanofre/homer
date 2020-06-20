locals {
  lb_name         = format("%s-lb-%s",var.workspace, var.app_name)
  tg_name         = format("%s-tg-%s",var.workspace, var.app_name)
  asg_name        = format("%s-asg-%s-",var.workspace, var.app_name)
  lc_name         = format("%s-lc%s",var.workspace, var.app_name)
  bucket_name     = format("%s-", var.bucket_name)
  bucket_env      = format("%s-userdata-", var.bucket_name_env)
  sg_by_user_name = format("%s-Ec2", var.app_name)
  lb_listener_arn = var.app_lb_listener_arn == null ? aws_lb_listener.this.0.arn : var.app_lb_listener_arn
  condition_path  = format("/%s/*", var.lb_condition_path == null ? var.app_name : var.lb_condition_path)
  # scheduled_start_time = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", var.scheduled_start_time == null ? timeadd(timestamp(), "1h") : var.scheduled_start_time)
  scheduled_action_name = format("[%s]%s",var.workspace, var.scheduled_action_name == null ? var.app_name : var.scheduled_action_name)
  tags = {
    Environment = var.workspace
    Owner       = "terraform"
  }
}
