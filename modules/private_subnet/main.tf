resource "aws_subnet" "private" {
  for_each = toset(var.azs)
  cidr_block = cidrsubnet(var.vpc_block, 8, index(var.azs, each.key))
  vpc_id     = var.vpc_id
  availability_zone = each.key

  tags = {
    Name = "${var.vpc_name}-private-${each.key}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route" "private_nat_default" {
  count = var.create_nat_route ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}