#######################public security group###################################
resource "aws_security_group" "public-security_group" {
    description = "Allow traffic to public subnets"
    vpc_id = var.vpc_id
    name = "public-security_group"
    tags = {
      "Name" = "public-security_group"
    }
}

##################security group rule#######################
#ingress ssh
resource "aws_security_group_rule" "ingress_public_ssh" {
  type = "ingress"
  #count = length(split(",",var.ingress_ports)) > 0 ? length(split(",",var.ingress_ports)) : 0
  # from_port = split(",",var.ingress_ports)[count.index]
  # to_port = split(",",var.ingress_ports)[count.index]
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-security_group.id
}

#ingress http
resource "aws_security_group_rule" "ingress_public_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.alb_security_group.id
  security_group_id = aws_security_group.public-security_group.id
}

#egress
resource "aws_security_group_rule" "egress_public" {
  type = "egress"
  count = length(split(",",var.egress_ports)) > 0 ? length(split(",",var.egress_ports)) : 0
  from_port = split(",",var.egress_ports)[count.index]
  to_port = split(",",var.egress_ports)[count.index]
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-security_group.id
}

############################################################
############################################################
######################private security group################
resource "aws_security_group" "private-security_group" {
    description = "Allow traffic to private subnets"
    vpc_id = var.vpc_id
    name = "private-security_group"
    tags = {
      "Name" = "private-security_group"
    }
}

##################security group rule#######################
#ingress ssh
resource "aws_security_group_rule" "ingress_private_ssh" {
  type = "ingress"
  # count = length(split(",",var.ingress_ports)) > 0 ? length(split(",",var.ingress_ports)) : 0
  # from_port = split(",",var.ingress_ports)[count.index]
  # to_port = split(",",var.ingress_ports)[count.index]
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = aws_security_group.public-security_group.id
  security_group_id = aws_security_group.private-security_group.id
}

#ingress http
resource "aws_security_group_rule" "ingress_private_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.public-security_group.id
  security_group_id = aws_security_group.private-security_group.id
}



#######################rds security_group rule#########################
resource "aws_security_group_rule" "ingress_private_rds" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = aws_security_group.public-security_group.id
  security_group_id = aws_security_group.private-security_group.id
}


#egress
resource "aws_security_group_rule" "egress_private" {
  type = "egress"
  count = length(split(",",var.egress_ports)) > 0 ? length(split(",",var.egress_ports)) : 0
  from_port = split(",",var.egress_ports)[count.index]
  to_port = split(",",var.egress_ports)[count.index]
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private-security_group.id
}



#######################################################################
#######################################################################
#########################alb security group############################
#######################public security group###################################
resource "aws_security_group" "alb_security_group" {
    description = "Security group to allow traffic into application load balancer"
    vpc_id = var.vpc_id
    name = "alb-security_group"
    tags = {
      "Name" = "alb-security_group"
    }
}

##################security group rule#######################
#ingress
resource "aws_security_group_rule" "ingress_public_alb" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_security_group.id
}

#egress
resource "aws_security_group_rule" "egress_public_alb" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_security_group.id
}


#############################################################
#############################################################
#########################outputs#############################
output "public_security_groups" {
  value = aws_security_group.public-security_group.id
}

output "private_security_groups" {
  value = aws_security_group.private-security_group.id
}
output "alb_sg"{
  value = aws_security_group.alb_security_group.id
}
