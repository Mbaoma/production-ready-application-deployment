output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_public_dns" {
  value = module.ec2.public_dns
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}

output "ssh_command" {
  value = "ssh ubuntu@${module.ec2.public_ip}"
}