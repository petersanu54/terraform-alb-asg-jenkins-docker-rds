variable "subnets" {
  type = list
}
variable "security_groups_rds" {
  type = list
}
variable "backup_retention_period" {
  default = 30
}
variable "storage_type" {
  default = "gp2"
}
variable "family" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "identifier" {}
variable "allocated_storage" {
  default = 10
}