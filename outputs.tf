output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.this.id
}

output "igw_id" {
  description = "ID do Internet Gateway criado"
  value       = aws_internet_gateway.igw.id
}

output "priv_subnet_id" {
  description = "ID das subnets privadas criadas"
  value       = module.private_subnet.subnet_ids

  precondition {
    condition     = length(module.private_subnet.subnet_ids) > 0
    error_message = "Nenhuma subnet privada foi criada."
  }
}

output "pub_subnet_id" {
  description = "ID das subnets públicas criadas"
  value       = module.public_subnet.subnet_ids

  precondition {
    condition     = length(module.public_subnet.subnet_ids) > 0
    error_message = "Nenhuma subnet pública foi criada."
  }
}

output "nat_address" {
  description = "IP público do Nat Gateway"
  value       = length(module.nat_gateway) > 0 ? module.nat_gateway[0].nat_address : null
}