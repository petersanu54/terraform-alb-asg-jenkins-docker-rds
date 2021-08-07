variable "alb_internal" {
  default = false
}
variable "vpc_id" {}
variable "subnets" {
  type = list
}
variable "iam_instance_profile" {}
variable "enable_cross_zone_load_balancing" {
  default = false
}
variable "alb_listener" {
  default = 80
}
variable "target_group_port" {
  default = 80
}
variable "target_type" {
  default = "instance"
}
variable "target_group_healthy_threshold" {
  default = 3
}
variable "target_group_unhealthy_threshold" {
  default = 2
}
variable "target_group_timeout" {
  default = 5
}
variable "target_group_interval" {
  default = 30
}
variable "target_group_path" {
  default = "/"
}
variable "target_port" {
  default = 80
}
variable "image_id" {
  default = "ami-0747bdcabd34c712a"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {}
variable "user_data" {}
variable "security_groups_alb" {
  type = list
}
variable "security_groups_launch_configuration" {
  type = list
}