# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Configure the AWS VM hosts

data "aws_availability_zones" "boundary" {}

resource "aws_vpc" "boundary_hosts_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "boundary_hosts_vpc"
  }
}

resource "aws_subnet" "boundary_hosts_subnet" {
  vpc_id                  = aws_vpc.boundary_hosts_vpc.id
  cidr_block              = aws_vpc.boundary_hosts_vpc.cidr_block
  availability_zone       = data.aws_availability_zones.boundary.names[0]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "boundary_hosts_subnet"
  }
}

resource "aws_security_group" "boundary_ssh" {
  name        = "boundary_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.boundary_hosts_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

variable "instances" {
  default = [
    "boundary-1-dev", 
    "boundary-2-dev", 
    "boundary-3-production", 
    "boundary-4-production"
  ]
}

variable "vm_tags" {
  default = [
    {"Name":"boundary-1-dev","service-type":"database", "application":"dev"},
    {"Name":"boundary-2-dev","service-type":"database", "application":"dev"},
    {"Name":"boundary-3-production","service-type":"database", "application":"production"},
    {"Name":"boundary-4-production","service-type":"database", "application":"prod"}
  ]
}

resource "aws_instance" "boundary_instance" {
  count                  = length(var.instances)
  ami                    = "ami-083602cee93914c0c"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.boundary_hosts_subnet.id
  vpc_security_group_ids = [aws_security_group.boundary_ssh.id]
  tags                   = var.vm_tags[count.index]
}