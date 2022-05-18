resource "aws_vpc" "vpc_lb" {
  cidr_block = var.alb.network
}

resource "aws_subnet" "subnet_lb" {
  for_each                = { for subnet in var.alb.subnets : subnet.cidr => subnet }
  vpc_id                  = aws_vpc.vpc_lb.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw_lb" {
  vpc_id = aws_vpc.vpc_lb.id
}

resource "aws_route_table" "route_table_lb" {
  vpc_id = aws_vpc.vpc_lb.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_lb.id
  }
}

resource "aws_route_table_association" "route_lb" {
  for_each       = { for subnet in var.alb.subnets : subnet.cidr => subnet }
  subnet_id      = aws_subnet.subnet_lb[each.value.cidr].id
  route_table_id = aws_route_table.route_table_lb.id
}