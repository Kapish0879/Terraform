output "vpc_id" {
    value = aws_vpc.my-vpc.id
}

output "public_subnet_id" {
    value = aws_subnet.public-subnet.id
}

output "private_subnet_id" {
    value = aws_subnet.private-subnet.id
}

output "sg_id" {
    value = aws_security_group.my-security-group.id
}
