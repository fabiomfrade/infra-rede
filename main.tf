data "aws_availability_zones" "available" {
  state = "available"
  
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_block
  enable_dns_support   = var.support_dns
  enable_dns_hostnames = var.dns_hostnames

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-vpc"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-igw"
    }
  )
}


# Chamada dos módulos de construção das subnets públicas e privadas

module "public_subnet" {
  source = "./modules/public_subnet"

  vpc_id         = aws_vpc.this.id
  vpc_name       = aws_vpc.this.tags["Name"]
  vpc_block      = var.vpc_block

  availability_zones = data.aws_availability_zones.available.names

  igw_id         = aws_internet_gateway.igw.id
  azs = var.selected_azs
}

module "private_subnet" {
  source = "./modules/private_subnet"

  vpc_id          = aws_vpc.this.id
  vpc_name        = aws_vpc.this.tags["Name"]
  vpc_block       = var.vpc_block
  # private_subnets = var.private_subnets
  azs = var.selected_azs
  create_nat_route = var.create_nat_gateway
  
  availability_zones = data.aws_availability_zones.available.names
  
  nat_gateway_id  = var.create_nat_gateway ? module.nat_gateway[0].nat_id : null
}

module "nat_gateway" {
  source = "./modules/nat_gateway"
  count  = var.create_nat_gateway ? 1 : 0

  vpc_name  = aws_vpc.this.tags["Name"]
  subnet_id = values(module.public_subnet.subnet_ids)[0]
  depends_on = [ aws_internet_gateway.igw ]
}