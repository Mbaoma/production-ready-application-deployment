output "repository_name" {
  value = aws_ecr_repository.assessment-server.name
}

output "repository_url" {
  value = aws_ecr_repository.assessment-server.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.assessment-server.arn
}