variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "Test-VPC"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_name" {
  description = "Name of the public subnet"
  type        = string
  default     = "PublicSubnet"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI for EC2 Instance Connect"
  type        = string
  default     = "ami-05b10e08d247fb927"
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "Aaa"
}

variable "instance_name" {
  description = "Tag name for the EC2 instance"
  type        = string
  default     = "Test2-EC2"
}


