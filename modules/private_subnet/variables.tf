variable "azs" {
  type = list(string)
}

variable "vpc_block" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "ID da VPC onde as subnets serão criadas"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "create_nat_route" {
  description = "Define se a Route Table privada deve criar a rota default para o NAT Gateway"
  type = bool
  default = false  
}

variable "nat_gateway_id" {
  description = "ID do NAT Gateway para rota de saída das subnets privadas. Se null, nenhuma rota default será criada"
  type        = string
  default     = null
}

variable "availability_zones" {
  description = "Lista de Zonas Disponíveis"
  type = list(string)  
}