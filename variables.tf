variable "regiao" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "perfil" {
  description = "Perfil AWS CLI para autenticação"
  type        = string
  default     = "default"
}

variable "vpc_block" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
  default     = "main"
}

variable "selected_azs" {
  description = "Lista de Zonas de disponibilidade onde as subnets serão criadas"
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
  
}

variable "create_nat_gateway" {
  description = "Habilita ou não a criação de estrutura de Nat Gateway"
  type        = bool
  default     = false

  validation {
    condition     = !(var.create_nat_gateway && length(var.selected_azs) == 0)
    error_message = "`Para criar um NAT Gateway é necessário ter ao menos uma subnet pública"
  }
}

variable "support_dns" {
  description = "Habilita ou não o suporte a DNS"
  type        = bool
  default     = true
}

variable "dns_hostnames" {
  description = "Habilita ou não o suporte a Hostname internamente"
  type        = bool
  default     = true
}