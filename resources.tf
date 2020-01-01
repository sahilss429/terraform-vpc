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
  vpc_id = aws_vpc.VPC-Test.id
  cidr_block = var.private_subnetCIDR
  map_public_ip_on_launch = var.mapPublicIPPrivateSubnet
  availability_zone = var.availability_zonePrivateSubnet
tags = {
  Name = "Private-subnet${count.index}"
}
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.VPC-Test.id
  cidr_block = var.public_subnetCIDR
  map_public_ip_on_launch = var.mapPublicIPPublicSubnet
  availability_zone = var.availability_zonePublicSubnet
tags = {
  Name = "Public-subnet${count.index}"
}
}
#create security groups
resource "aws_security_group" "VPC-Test-sg1" {
  vpc_id = aws_vpc.VPC-Test.id
  name   = "SSHD"
  description = "External SSHD ports and IPs"
}
