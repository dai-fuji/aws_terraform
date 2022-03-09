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
