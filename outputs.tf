output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main_vpc.id
}

output "subnet_id" {
  description = "The ID of the created Subnet"
  value       = aws_subnet.public_subnet.id
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "elastic_ip" {
  description = "The allocated Elastic IP for the EC2 instance"
  value       = aws_eip.elastic_ip.public_ip
}
