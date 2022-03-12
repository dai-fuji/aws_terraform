#---------------------------------------
# VPC
#---------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.name}-vpc"
  }
}

#-----------------------------------------------------------------------------------------
# Subnet public/2groups private/2groups
#-----------------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.name}-pub-subnet${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + length(aws_subnet.public)) #publicの連続でカウント値を使う為にlengthを足す
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.name}-pri-subnet${count.index + 1}"
  }
}

#-----------------------------------------------------------------------------------------
# Internet gateway
#-----------------------------------------------------------------------------------------

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-ig"
  }
}

#-----------------------------------------------------------------------------------------
# Route table
#-----------------------------------------------------------------------------------------

resource "aws_route_table_association" "subnet" {
  count          = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index) #elementでリストから取り出す *で複数あるものをリストとして認識する
  route_table_id = aws_route_table.routetable.id
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-routetable"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

#-----------------------------------------------------------------------------------------
# Load balancer
#-----------------------------------------------------------------------------------------

