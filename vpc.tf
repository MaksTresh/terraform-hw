resource "aws_vpc" "IS_VPC1" {
  cidr_block           = var.vpc_1_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "VPC-1",
    Owner       = "maxim-goglazin@mail.ru",
    Environment = "Production",
    Description = "First VPC",
  }
}

resource "aws_vpc" "IS_VPC2" {
  cidr_block           = var.vpc_2_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "VPC-2",
    Owner       = "maxim-goglazin@mail.ru",
    Environment = "Production",
    Description = "Second VPC",
  }
}


# Public subnets
resource "aws_subnet" "aws-1-subnet-public" {
  vpc_id                  = aws_vpc.IS_VPC1.id
  cidr_block              = var.vpc_1_cidr_public
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "First public subnet",
  }
}


resource "aws_subnet" "aws-2-subnet-public" {
  vpc_id                  = aws_vpc.IS_VPC2.id
  cidr_block              = var.vpc_2_cidr_public
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Second public subnet",
  }
}

resource "aws_subnet" "aws-3-subnet-public" {
  vpc_id                  = aws_vpc.IS_VPC1.id
  cidr_block              = var.vpc_3_cidr_public
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Third public subnet",
  }
}

# Private subnets
resource "aws_subnet" "aws-1-subnet-private" {
  vpc_id            = aws_vpc.IS_VPC1.id
  cidr_block        = var.vpc_1_cidr_private
  availability_zone = "us-east-1b"
  tags = {
    Name = "First private subnet",
  }
}

resource "aws_subnet" "aws-2-subnet-private" {
  vpc_id            = aws_vpc.IS_VPC2.id
  cidr_block        = var.vpc_2_cidr_private
  availability_zone = "us-east-1b"
  tags = {
    Name = "Second private subnet",
  }
}

resource "aws_subnet" "aws-3-subnet-private" {
  vpc_id            = aws_vpc.IS_VPC1.id
  cidr_block        = var.vpc_3_cidr_private
  availability_zone = "us-east-1a"

  tags = {
    Name = "Third private subnet",
  }
}

# Gateway
resource "aws_internet_gateway" "gateway-1" {
  vpc_id = aws_vpc.IS_VPC1.id
}

resource "aws_internet_gateway" "gateway-2" {
  vpc_id = aws_vpc.IS_VPC2.id
}


resource "aws_vpc_peering_connection" "VPCPeer" {
  peer_vpc_id = aws_vpc.IS_VPC1.id
  vpc_id      = aws_vpc.IS_VPC2.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "Peer Between 2 VPC's"
  }
}