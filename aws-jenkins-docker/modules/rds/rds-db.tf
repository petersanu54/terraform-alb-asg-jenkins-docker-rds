##########retrieve db cred from secrets manager using data
data "aws_secretsmanager_secret_version" "creds" {
  #the name you gave to your secret
  secret_id = "ubuntusecretmanagerdbnew"
  depends_on = [
    aws_secretsmanager_secret.ubuntusecretmanagerdbnew
  ]
}

###########jsondecode the db cred#########################
locals {  
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

###################################################
###################################################
##########rds subnet group##############
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "ubuntu-db-subnet-group"
  subnet_ids = var.subnets
}


########red-mariadb parameter group################
resource "aws_db_parameter_group" "db_parameter_group" {
  name = "ubuntu-db-parameter-group"
  family = var.family
  parameter{
    name = "max_allowed_packet"
    value = "16777216"
  }
}

##########rds instance########################
resource "aws_db_instance" "db" {
    name = "ubuntudb"
    engine = var.engine
    engine_version = var.engine_version
    instance_class = var.instance_class
    identifier = var.identifier
    username = local.db_creds.username
    password = local.db_creds.password
    storage_type = var.storage_type
    allocated_storage = var.allocated_storage
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    parameter_group_name = aws_db_parameter_group.db_parameter_group.name
    multi_az = false
    vpc_security_group_ids = var.security_groups_rds
    backup_retention_period = var.backup_retention_period
    # availability_zone = aws_subnet.ubuntu_private_subnet_1a.availability_zone
    skip_final_snapshot = true
    tags={
      Name = "ubuntu-rds-mariadb"
    }
  #   depends_on = [
  #   aws_secretsmanager_secret.ubuntusecretmanagerdbnew
  # ]
}
