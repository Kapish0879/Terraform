resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.public_az
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}  

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_az
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "my-nat-gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnet.id
  tags = {
    Name = "my-nat-gateway"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat-gateway.id
  }
}

resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_security_group" "my-security-group" {
  name        = var.sg_name
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = var.ssh_port  
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
        from_port   = var.http_port
        to_port     = var.http_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-firewall"
  }
}   
