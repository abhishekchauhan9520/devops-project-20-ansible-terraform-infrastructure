output "public_ips" {
  description = "Public IPs for the provisioned EC2 instances."
  value       = aws_instance.app[*].public_ip
}

output "private_ips" {
  description = "Private IPs for the provisioned EC2 instances."
  value       = aws_instance.app[*].private_ip
}

output "instance_ids" {
  description = "EC2 instance IDs."
  value       = aws_instance.app[*].id
}
