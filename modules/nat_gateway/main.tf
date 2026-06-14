resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id

  # depends_on = [aws_eip.nat]
  # depends_on = [var.igw_id]

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}