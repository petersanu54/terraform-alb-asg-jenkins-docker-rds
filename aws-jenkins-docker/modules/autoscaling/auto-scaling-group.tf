#############################auto scaling group###############################
resource "aws_autoscaling_group" "autoscaling_group_public" {
    name = "ubuntu_autoscaling_group_public"
    max_size = var.max_size_public
    min_size = var.min_size_public
    vpc_zone_identifier = var.vpc_zone_identifier_public
    default_cooldown = var.cooldown_period
    launch_configuration = var.launch_configuration
    health_check_grace_period = var.health_check_grace_period
    health_check_type = var.health_check_type
    desired_capacity = var.desired_capacity
    target_group_arns = var.target_group_arns
    force_delete = var.force_delete
    # Required to redeploy without an outage.
    lifecycle {
      create_before_destroy = true
    }

    tag{
      key = "Name"
      value = "ubuntu_autoscaling_group"
      propagate_at_launch = true
    }
}

