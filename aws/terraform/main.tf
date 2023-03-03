# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Configure the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73"
      }
  }
  required_version = ">= 0.14.9"
}

output "boundary_access_key_id" {
    value = aws_iam_access_key.boundary.id
}

output "boundary_secret_access_key" {
  value = aws_iam_access_key.boundary.secret
  sensitive = true
}

provider "aws" {
}

resource "aws_iam_user" "boundary" {
  name = "boundary"
  path = "/"
}

resource "aws_iam_access_key" "boundary" {
  user = aws_iam_user.boundary.name
}

resource "aws_iam_user_policy" "BoundaryDescribeInstances" {
  name = "BoundaryDescribeInstances"
  user = aws_iam_user.boundary.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}