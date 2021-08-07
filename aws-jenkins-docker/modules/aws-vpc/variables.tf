variable "vpc_cidr_block" {}
variable "vpc_tag" {}
variable "enable_dns_hostnames" {
  default = true
}
variable "subnet_cidr_block_public" {
  type = list(string)
}
variable "subnet_cidr_block_private" {
  type = list(string)
}
variable "availability_zone_public" {
  type = list(string)
}
variable "availability_zone_private" {
  type = list(string)
}
variable "public_subnet" {
  type = list(any)
}
variable "private_subnet" {
  type = list(any)
}
variable "total_natgateway_required" {
  default = 1
}
