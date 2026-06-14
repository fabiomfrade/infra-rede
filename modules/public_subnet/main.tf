resource "aws_subnet" "public" {
  for_each = toset(var.azs)
  vpc_id     = var.vpc_id
  cidr_block = cidrsubnet(var.vpc_block, 8, index(var.azs, each.key) + 100)
  availability_zone = each.key

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
}