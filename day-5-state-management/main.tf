resource "aws_instance" "public-instance" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  key_name      = "Kapish-med-erp"
  vpc_security_group_ids = ["sg-01ec9cb850e52eb3f"]
  count = 2
  tags = {
    Name = "PublicInstance"
  } 
}