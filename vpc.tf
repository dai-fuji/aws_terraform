#---------------------------------------
# VPC
#---------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block = "100.0.0.0/16"
  tags = {
    Name = "tf-vpc"
  }
}

#-----------------------------------------------------------------------------------------
# Subnet public/2groups private/2groups
#-----------------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "tf-pub-subnet${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + length(aws_subnet.public)) #publicの連続でカウント値を使う為にlengthを足す
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "tf-pri-subnet${count.index + 1}"
  }
}

#-----------------------------------------------------------------------------------------
# Internet gateway
#-----------------------------------------------------------------------------------------

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-ig"
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
    Name = "tf-routetable"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

#-----------------------------------------------------------------------------------------
# Output
#-----------------------------------------------------------------------------------------

output "vpc_id" {
  value = "aws_vpc.vpc.id"
}
output "pub_subnets" {
  value = aws_subnet.public.*.id
}
output "pri_subnets" {
  value = aws_subnet.private.*.id
}


