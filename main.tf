provider "aws" {
  access_key = "*************************"
  secret_key = "******************************"
  region     = "us-west-2"
}

# Creating a VPC with public and private subnets

resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags {
  Name = "terraform" }
}
resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.terraform-vpc.id}"
  cidr_block ="10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-2a"
  tags {
  Name = "public" }
}
resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.terraform-vpc.id}"
  cidr_block ="10.0.100.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-west-2b"
  tags {
  Name = "private" }
}

# Create new Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.terraform-vpc.id}"
  tags {
  Name = "internet-gateway" }
}

# Craeting Route table

resource "aws_route_table" "rt1" {
  vpc_id = "${aws_vpc.terraform-vpc.id}"
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags {
  Name = "Default" }
}

# Attache the public subnet to Route table

resource "aws_route_table_association" "a" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.rt1.id}"
}

