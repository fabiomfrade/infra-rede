variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet Pública a ser associeada ao NAT"
  type        = string
}