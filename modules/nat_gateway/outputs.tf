output "eip_arn" {
  description = "ARN do Elastic IP criado"
  value       = aws_eip.nat.arn
}

output "eip_address" {
  description = "IP público do EIP criado"
  value       = aws_eip.nat.public_ip
}

output "nat_id" {
  description = "ID do NAT Gateway criado"
  value       = aws_nat_gateway.public_nat.id
}

output "nat_address" {
  description = "IP do NAT Gateway"
  value       = aws_nat_gateway.public_nat.public_ip
}