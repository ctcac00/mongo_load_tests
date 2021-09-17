# EC2 loadtest-demo
output "loadtest-demo_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = [for ec2 in module.loadtest-demo : ec2.public_dns]
}

output "loadtest-private_dns" {
  description = "The private DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = [for ec2 in module.loadtest-demo : ec2.private_dns]
}
