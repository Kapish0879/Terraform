resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_id]
  subnet_id = var.public_subnet_id
  user_data = file("/home/ubuntu/Terraform/day-4/modules/ec2/user_data.sh")
  tags = {
    Name = "my-ec2-public-instance"
  }
}


resource "aws_instance" "private_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_id]
  subnet_id = var.private_subnet_id
  user_data = file("/home/ubuntu/Terraform/day-4/modules/ec2/user_data.sh")
  tags = {
    Name = "my-ec2-private-instance"
  }
}
