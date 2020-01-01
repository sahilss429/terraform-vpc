#create vpc
resource "aws_vpc" "VPC-Test" {
  cidr_block = "${var.aws_ip_cidr_range}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "VPC-Test"
  }
}
#create subnets
resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.VPC-Test.id}"
  cidr_block = "${var.private_subnetCIDR}"
  map_public_ip_on_launch = "${var.mapPublicIPPrivateSubnet}"
  availability_zone = "${var.availability_zonePrivateSubnet}"
tags = {
  Name = "Private-subnet${count.index}"
}
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.VPC-Test.id}"
  cidr_block = "${var.public_subnetCIDR}"
  map_public_ip_on_launch = "${var.mapPublicIPPublicSubnet}"
  availability_zone = "${var.availability_zonePublicSubnet}"
tags = {
  Name = "Public-subnet${count.index}"
}
}
#create security groups
resource "aws_security_group" "VPC-Test-sg1" {
  vpc_id = "${aws_vpc.VPC-Test.id}"
  name   = "SSHD"
  description = "External SSHD ports and IPs"
}

#create internet gateway
resource "aws_internet_gateway" "VPC-Test-IGW" {
    vpc_id = "${aws_vpc.VPC-Test.id}"
    tags {
      name = "VPC-Test-IGW"
    }
}
#create Nat eip
resource "aws_eip" "nat" {
}

#create nat gateway
resource "aws_nat_gateway" "VPC-Test-natgateway" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.private_subnet.id}"
  depends_on = "${aws_internet_gateway.VPC-Test-IGW}"
}

#create route tables
resource "aws_route_table" "VPC-Test-privateRT" {
  vpc_id = "${aws_vpc.VPC-Test.id}"
  tags {
    Name = "VPC-Test-privateRT"
  }
}

resource "aws_route_table" "VPC-Test-publicRT" {
  vpc_id = "${aws_vpc.VPC-Test.id}"
  tags {
    Name = "VPC-Test-publicRT"
  }
}


#Internet access
resource "aws_route" "VPC-Test-publicR" {
  route_table_id = "${aws_route_table.VPC-Test-publicRT.id}"
  destination_cidr_block = "${var.destcidrblock}"
  gateway_id = "${aws_internet_gateway.VPC-Test-IGW.id}"
}
resource "aws_route" "VPC-Test-privateR" {
  route_table_id = "${aws_route_table.VPC-Test-privateRT.id}"
  destination_cidr_block = "${var.destcidrblock}"
  gateway_id = "${aws_nat_gateway.VPC-Test-natgateway.id}"
}
#Associate route table
resource "aws_route_table_association" "VPC-Test-private-subnet-association" {
  subnet_id = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.VPC-Test-privateRT.id}"
}
resource "aws_route_table_association" "VPC-Test-public-subnet-association" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.VPC-Test-publicRT.id}"
}
