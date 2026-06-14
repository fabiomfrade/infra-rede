output "subnet_ids" {
  description = "ID da(s) Subnet(s) pública(s) criada(s)"
  value       = { for az, s in aws_subnet.public : az => s.id }
}