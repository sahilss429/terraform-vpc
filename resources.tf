#create vpc
resource "aws_vpc" "VPC-Test02" {
  cidr_block = "${var.aws_ip_cidr_range}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC-Test02"
  }
}
#create subnets
resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.VPC-Test02.id}"
  cidr_block = "${var.private_subnetCIDR}"
  map_public_ip_on_launch = "${var.mapPublicIPPrivateSubnet}"
  availability_zone = "${var.availability_zonePrivateSubnet}"
tags = {
  Name = "Private-subnet"
}
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.VPC-Test02.id}"
  cidr_block = "${var.public_subnetCIDR}"
  map_public_ip_on_launch = "${var.mapPublicIPPublicSubnet}"
  availability_zone = "${var.availability_zonePublicSubnet}"
tags = {
  Name = "Public-subnet"
}
}
#create security groups
resource "aws_security_group" "VPC-Test02-sg1" {
  vpc_id = "${aws_vpc.VPC-Test02.id}"
  name   = "SSHD"
  description = "External SSHD ports and IPs"
}

#create internet gateway
resource "aws_internet_gateway" "VPC-Test02-IGW" {
    vpc_id = "${aws_vpc.VPC-Test02.id}"
    tags = {
      name = "VPC-Test02-IGW"
    }
}
#create Nat eip
resource "aws_eip" "nat" {
}

#create nat gateway
resource "aws_nat_gateway" "VPC-Test02-natgateway" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.private_subnet.id}"
}

#create route tables
resource "aws_route_table" "VPC-Test02-privateRT" {
  vpc_id = "${aws_vpc.VPC-Test02.id}"
  tags = {
    Name = "VPC-Test02-privateRT"
  }
}

resource "aws_route_table" "VPC-Test02-publicRT" {
  vpc_id = "${aws_vpc.VPC-Test02.id}"
  tags = {
    Name = "VPC-Test02-publicRT"
  }
}


#Internet access
resource "aws_route" "VPC-Test02-publicR" {
  route_table_id = "${aws_route_table.VPC-Test02-publicRT.id}"
  destination_cidr_block = "${var.destcidrblock}"
  gateway_id = "${aws_internet_gateway.VPC-Test02-IGW.id}"
}
resource "aws_route" "VPC-Test02-privateR" {
  route_table_id = "${aws_route_table.VPC-Test02-privateRT.id}"
  destination_cidr_block = "${var.destcidrblock}"
  gateway_id = "${aws_nat_gateway.VPC-Test02-natgateway.id}"
}
#Associate route table
resource "aws_route_table_association" "VPC-Test02-private-subnet-association" {
  subnet_id = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.VPC-Test02-privateRT.id}"
}
resource "aws_route_table_association" "VPC-Test02-public-subnet-association" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.VPC-Test02-publicRT.id}"
}
