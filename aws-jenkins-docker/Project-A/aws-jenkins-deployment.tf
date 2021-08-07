##############AWS VPC################
module "aws-vpc"{
    source = "../modules/aws-vpc"
    vpc_cidr_block = "192.168.0.0/16"
    vpc_tag = "ubuntu-vpc"
    enable_dns_hostnames = true
    subnet_cidr_block_public = ["192.168.0.0/18","192.168.128.0/18"]
    subnet_cidr_block_private = ["192.168.64.0/18","192.168.192.0/18"]
    availability_zone_public = ["us-east-1a", "us-east-1b"]
    availability_zone_private = ["us-east-1a", "us-east-1b"]
    public_subnet = ["public-subnet-1a", "public-subnet-1b"]
    private_subnet = ["private-subnet-1a", "private-subnet-1b"]
    total_natgateway_required = 2
}


################AWS security group##############
module "security_group" {
  source = "../modules/securitygroups"
  vpc_id = module.aws-vpc.vpc_id
  egress_ports = "0"
}


##############instance profile##################
module "instance_profile" {
  source = "../modules/instance-role"
}


##############autoscaling group#################
module "autoscaling-group_public" {
    source = "../modules/autoscaling"
    max_size_public = 4
    min_size_public = 1
    vpc_zone_identifier_public = module.aws-vpc.public_subnet_id
    cooldown_period = 200
    launch_configuration = module.application_load_balancer.launch_configuration_name
    health_check_grace_period = 300
    target_group_arns = [module.application_load_balancer.target_group_arn]
    health_check_type = "ELB"
    desired_capacity = 2
    force_delete = true   
}


##############application load balancer######
module "application_load_balancer" {
  source = "../modules/alb"
  alb_internal = false
  security_groups_alb = [module.security_group.alb_sg]
  subnets = module.aws-vpc.public_subnet_id
  enable_cross_zone_load_balancing = true
  # connection_draining = true
  # connection_draining_timeout = 400
############alb listner##############
  alb_listener = 80
############alb target group#########
  target_group_port = 80
  vpc_id = module.aws-vpc.vpc_id
  target_type = "instance"
  target_group_healthy_threshold = 3
  target_group_unhealthy_threshold = 2
  target_group_timeout = 5
  target_group_interval = 30
  target_group_path = "/"
  target_port = 80
##########launch configuration##########
  image_id = "ami-0747bdcabd34c712a"
  security_groups_launch_configuration = [module.security_group.public_security_groups]
  instance_type = "t2.micro"
  iam_instance_profile = module.instance_profile.iam_instance_profile_name
  key_name = "master"
  user_data = file("${path.module}/script.sh")
  #user_data = "#!/bin/bash\n sudo apt-get update -y && sudo apt-get install -f\n sudo apt-get update -y && sudo apt upgrade -y\n sudo apt-get install nginx -y\n sudo systemctl start nginx\n MYIP=`ifconfig | grep inet | awk 'NR==1, NR==1 {print$2}'`\n sudo mkdir -p /var/www/html\n sudo cd /var/www/html\n sudo touch index.html\n sudo chmod 777 -R /var/www/html/index.html\n echo 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"
}

#########################################################################

##################################################################
###############aws rds##############################################
module "aws_rds" {
  source = "../modules/rds"
  subnets = module.aws-vpc.public_subnet_id
  security_groups_rds = [module.security_group.private_security_groups]
  backup_retention_period = 30
  storage_type = "gp2"
  family = "mariadb10.5"
  engine = "mariadb"
  engine_version = "10.5.8"
  instance_class = "db.t2.micro"
  identifier = "ubuntu-rds-mariadb"
  allocated_storage = 10 
}



