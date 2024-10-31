locals {
  private_subnet_cidrs = concat(var.private_app_subnet_cidrs, var.private_data_subnet_cidrs)
}

resource "aws_subnet" "public" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_app" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-app-${count.index + 1}"
  }
}

resource "aws_subnet" "private_data" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_data_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-data-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "public" {
  count         = length(aws_subnet.public)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-public-nat-gateway-${count.index + 1}"
  }
  depends_on = [var.internet_gateway_id, aws_eip.nat]
}

resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_app" {
  count  = length(var.availability_zones)
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-private-app-rt-${count.index + 1}"
  }
}

resource "aws_route_table" "private_data" {
  count  = length(var.availability_zones)
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-private-data-rt-${count.index + 1}"
  }
}

resource "aws_route" "private_app_nat_gateway" {
  count                  = length(aws_route_table.private_app)
  route_table_id         = aws_route_table.private_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public[count.index].id
}

resource "aws_route" "private_data_nat_gateway" {
  count                  = length(aws_route_table.private_data)
  route_table_id         = aws_route_table.private_data[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public[count.index].id
}

resource "aws_route_table_association" "private_app" {
  count          = length(aws_subnet.private_app)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}

resource "aws_route_table_association" "private_data" {
  count          = length(aws_subnet.private_data)
  subnet_id      = aws_subnet.private_data[count.index].id
  route_table_id = aws_route_table.private_data[count.index].id
}

resource "aws_efs_file_system" "main" {
  creation_token = "${var.project_name}-efs"
  encrypted      = false

  tags = {
    Name = "${var.project_name}-efs"
  }
}

resource "aws_efs_mount_target" "main" {
  count           = length(aws_subnet.private_data)
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = aws_subnet.private_data[count.index].id
  security_groups = [aws_security_group.efs.id]
}

