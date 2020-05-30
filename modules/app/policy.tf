resource "aws_autoscaling_schedule" "scaling_down" {
  count = var.scheduled_recurrence_down == null ? 0 : 1

  scheduled_action_name  = format("%s_down",local.scheduled_action_name)
  min_size               = var.scheduled_min_size
  max_size               = var.scheduled_max_size
  desired_capacity       = var.scheduled_desired_capacity
  start_time             = var.scheduled_start_time
  end_time               = var.scheduled_end_time
  recurrence             = var.scheduled_recurrence_down
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_schedule" "scaling_up" {
  count = var.scheduled_recurrence_up == null ? 0 : 1

  scheduled_action_name  = format("%s_up",local.scheduled_action_name)
  min_size               = var.scheduled_min_size
  max_size               = var.scheduled_max_size
  desired_capacity       = var.scheduled_desired_capacity
  start_time             = var.scheduled_start_time
  end_time               = var.scheduled_end_time
  recurrence             = var.scheduled_recurrence_up
  autoscaling_group_name = aws_autoscaling_group.this.name
}
