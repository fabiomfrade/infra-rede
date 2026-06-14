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

variable "igw_id" {
  description = "ID do Internet Gateway"
  type        = string
}

variable "availability_zones" {
  description = "Lista de Zonas Disponíveis"
  type = list(string)  
}

variable "azs" {
  type = list(string)
}