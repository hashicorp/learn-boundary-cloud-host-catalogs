# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Configure the AWS hosts
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

resource "aws_security_group" "boundary-ssh" {
  name        = "boundary_allow_ssh"
  description = "Allow SSH inbound traffic"

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

resource "aws_instance" "boundary-instance" {
  count                  = length(var.instances)
  ami                    = "ami-083602cee93914c0c"
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1a"
  security_groups        = ["boundary_allow_ssh"]
  vpc_security_group_ids = ["${aws_security_group.boundary-ssh.id}"]
  tags                   = var.vm_tags[count.index]
}