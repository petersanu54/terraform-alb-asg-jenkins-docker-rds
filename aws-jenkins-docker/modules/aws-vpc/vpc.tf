#############AWS VPC###############
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = {
      Name = var.vpc_tag
    }
}

################################### AWS Public subnets ##########################################
resource "aws_subnet" "public_subnet" {
  count = length(var.subnet_cidr_block_public) > 0 ? length(var.subnet_cidr_block_public) : 0
  availability_zone = var.availability_zone_public[count.index]
  cidr_block = var.subnet_cidr_block_public[count.index]
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.public_subnet[count.index]
  }
}


#internet gateway
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
    tags ={
      Name = "${var.vpc_tag}_internet_gateway"
    }
}

#public route table
resource "aws_route_table" "public_route_table" {
      vpc_id = aws_vpc.vpc.id
      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
      }
      tags = {
        Name = "${var.vpc_tag}_public_route_table"
      }
}

############################## AWS Private subnets #######################################
#private subnet
resource "aws_subnet" "private_subnet" {
    count = length(var.subnet_cidr_block_private) > 0 ? length(var.subnet_cidr_block_private) : 0
    availability_zone = var.availability_zone_private[count.index]
    cidr_block = var.subnet_cidr_block_private[count.index]
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = var.private_subnet[count.index]
    }
}

#elastic-ip
resource "aws_eip" "eip" {
    vpc = true
    count = var.total_natgateway_required > 0 ? var.total_natgateway_required : 0
    tags = {
      "Name" = "eip-${count.index + 1}"
    }
}

#nat-gateway
resource "aws_nat_gateway" "nat_gateway" {
      count = var.total_natgateway_required > 0 ? var.total_natgateway_required : 0
      allocation_id = aws_eip.eip.*.id[count.index]
      subnet_id = aws_subnet.public_subnet.*.id[count.index]
      tags = {
        "Name" = "${var.public_subnet[count.index]}-NG"
      }
}

#private route table
resource "aws_route_table" "private_route_table" {
    count = length(var.private_subnet) > 0 ? length(var.private_subnet) : 0
    vpc_id = aws_vpc.vpc.id
    route{
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
    }
    tags = {
      Name = "${var.vpc_tag}_private_route_table_${var.private_subnet[count.index]}"
    }
}


#public route table association
resource "aws_route_table_association" "public_rt_association" {
  count = length(var.public_subnet) > 0 ? length(var.public_subnet) : 0
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

#private route table association
resource "aws_route_table_association" "private_rt_association" {
  count = length(var.private_subnet) > 0 ? length(var.private_subnet) : 0
  subnet_id = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_route_table.*.id[count.index]
}


######################################################################
######################################################################
#######################outputs########################################

output "vpc_id"{
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}