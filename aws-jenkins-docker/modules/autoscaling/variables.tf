variable "vpc_zone_identifier_public" {
    type = list
}
variable "max_size_public" {
    type = number
}
variable "min_size_public" {
    type = number
}
variable "cooldown_period" {
    default = 200
}
variable "launch_configuration" {}
variable "health_check_grace_period" {
  default = 300
}
variable "health_check_type" {
  default = "EC2"
}
variable "desired_capacity" {
  type = number
}
variable "force_delete" {
  default = true
}
variable "target_group_arns" {
  type = list
}