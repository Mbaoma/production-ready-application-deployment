output "instance_id" {
  value = aws_instance.assessment-server.id
}

output "public_ip" {
  value = aws_instance.assessment-server.public_ip
}

output "public_dns" {
  value = aws_instance.assessment-server.public_dns
}