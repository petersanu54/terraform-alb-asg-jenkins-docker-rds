#############################application load balancer################################
resource "aws_lb" "alb" {
    name = "ubuntu-alb"
    internal = var.alb_internal
    subnets = var.subnets
    load_balancer_type = "application"
    security_groups = var.security_groups_alb
    tags={
      Name = "ubuntu-alb"
    }
}


###################################alb listener##############################
resource "aws_lb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = var.alb_listener
    protocol = "HTTP"
    default_action{
      type = "forward"
      target_group_arn = aws_lb_target_group.ubuntu_TG.arn
    }
}


#################################alb target group###########################
resource "aws_lb_target_group" "ubuntu_TG" {
    name = "ubuntu-TG"
    port = var.target_group_port
    vpc_id = var.vpc_id
    protocol = "HTTP"
    target_type = var.target_type
    health_check {
      healthy_threshold = var.target_group_healthy_threshold
      unhealthy_threshold = var.target_group_unhealthy_threshold
      timeout = var.target_group_timeout
      interval = var.target_group_interval
      path = var.target_group_path
      port = var.target_port
      protocol = "HTTP"
    }
  }


###############################launch configuration##########################
resource "aws_launch_configuration" "launch_configuration" {
    name = "ubuntu_launch_configuration"
    image_id = var.image_id
    instance_type = var.instance_type
    associate_public_ip_address = true
    security_groups = var.security_groups_launch_configuration
    key_name = var.key_name
    iam_instance_profile = var.iam_instance_profile
    user_data = var.user_data
    lifecycle {
    create_before_destroy = true
  }
}


output "launch_configuration_name" {
  value = aws_launch_configuration.launch_configuration.name
}

output "target_group_arn" {
  value = aws_lb_target_group.ubuntu_TG.arn
}

output "alb_dns"{
  value = aws_lb.alb.dns_name
}
