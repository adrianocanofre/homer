resource "aws_autoscaling_schedule" "scheduled_down" {
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

resource "aws_autoscaling_schedule" "scheduled_up" {
  count = var.scheduled_recurrence_up == null ? 0 : 1

  scheduled_action_name  = format("%s_up",local.scheduled_action_name)
  min_size               = var.asg_min_size
  max_size               = var.asg_max_size
  desired_capacity       = var.asg_desired_capacity
  start_time             = var.scheduled_start_time
  end_time               = var.scheduled_end_time
  recurrence             = var.scheduled_recurrence_up
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "scaling_up" {
  name                   = format("[%s]%s_cpu_policy_up", var.workspace, var.app_name)
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = var.scaling_adjustment_type
  scaling_adjustment     = var.scaling_adjustment_up
  cooldown               = var.scaling_cooldown
  policy_type            = var.scaling_policy_type
}


resource "aws_autoscaling_policy" "scaling_down" {
  name                   = format("[%s]%s_cpu_policy_down", var.workspace, var.app_name)
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = var.scaling_adjustment_type
  scaling_adjustment     = var.scaling_adjustment_down
  cooldown               = var.scaling_cooldown
  policy_type            = var.scaling_policy_type
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = format("[%s]%s_high_cpu_alarm", var.workspace, var.app_name)
  alarm_description   = format("[%s]High cpu alarm for %s", var.workspace, var.app_name)
  comparison_operator = var.metric_comparison_operator_high
  evaluation_periods  = var.metric_evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  period              = var.metric_period
  statistic           = var.metric_statistic
  threshold           = var.metric_threshold_high
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scaling_down.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = format("[%s]%s_low_cpu_alarm", var.workspace, var.app_name)
  alarm_description   = format("[%s]Low cpu alarm for %s", var.workspace, var.app_name)
  comparison_operator = var.metric_comparison_operator_low
  evaluation_periods  = var.metric_evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  period              = var.metric_period
  statistic           = var.metric_statistic
  threshold           = var.metric_threshold_low
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scaling_down.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
}
