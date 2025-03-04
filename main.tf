provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Subnet Configuration (Public Subnet)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name
  }
}

# Internet Gateway for Public Internet Access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "InternetGateway"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group allowing SSH and HTTP
resource "aws_security_group" "sg" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Security Group"
  }
}

# EC2 Instance with EC2 Instance Connect, CPU Count, and CloudWatch Monitoring
resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true # ✅ Ensure Public IP
  monitoring                  = true # ✅ Enable CloudWatch detailed monitoring

  # Enable EC2 Instance Connect and CPU settings
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y ec2-instance-connect
    systemctl enable --now ec2-instance-connect
  EOF

  tags = {
    Name = var.instance_name
  }
}

# Elastic IP for Static Public IP
resource "aws_eip" "elastic_ip" {
  instance = aws_instance.ec2_instance.id
  tags = {
    Name = "ElasticIP"
  }
}
