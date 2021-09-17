variable "public_ip" {
  description = "The public IP address of your local machine"
}

variable "vpc_id" {
  description = "The VPC ID where the EC2 instances will be created"
}

variable "owner" {
  description = "Required AWS owner tag"
}

variable "purpose" {
  description = "Required AWS purpose tag"
}

variable "expire-on" {
  description = "Required AWS expire-on tag"
}

variable "region" {
  description = "AWS region"
}

variable "key_name" {
  description = "Key name for an existing key pair in AWS"
}

variable "subnet_id" {
  description = "The AWS subnet id"
}
