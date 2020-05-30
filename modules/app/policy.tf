resource "aws_autoscaling_schedule" "this" {
  scheduled_action_name  = var.scheduled_action_name
  min_size               = var.schedule_min_size
  max_size               = var.schedule_max_size
  desired_capacity       = var.schedule_desired_capacity
  start_time             = var.schedule_start_time
  end_time               = var.schedule_end_time
  recurrence             = var.schedule_recurrence
  autoscaling_group_name = aws_autoscaling_group.this.name
}
