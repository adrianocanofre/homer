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
  min_size               = var.scheduled_min_size
  max_size               = var.scheduled_max_size
  desired_capacity       = var.scheduled_desired_capacity
  start_time             = var.scheduled_start_time
  end_time               = var.scheduled_end_time
  recurrence             = var.scheduled_recurrence_up
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "scaling_up" {
  name                   = "cpu-policy-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


resource "aws_autoscaling_policy" "scaling_down" {
  name                   = "cpu-policy-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-alarm"
  alarm_description   = "High cpu alarm for webserver"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scaling_down.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-alarm"
  alarm_description   = "Low cpu alarm for webserver"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "30"
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scaling_down.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
}
