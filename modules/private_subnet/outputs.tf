output "subnet_ids" {
  description = "ID das subnets privadas criadas"
  value = { for az, s in aws_subnet.private : az => s.id }
}