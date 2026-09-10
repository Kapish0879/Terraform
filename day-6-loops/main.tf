resource "aws_instance" "ec2" {
    for_each = tomap({
        server1 = "t3.micro"
        server2 = "t2.medium"
        server3 = "t3.small"
    })
    ami           = "ami-0b6d9d3d33ba97d99"
    instance_type = each.value
    key_name      = "Kapish-med-erp"
    tags = {
        Name = "EC2Instance"
    }
  
}