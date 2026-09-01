provider "aws" {
    region = "us-east-1"
    key_name = "kapish"
  
}

resource "aws_instance" "ec2" {
    ami           = "var.ami"
    instance_type = "var.instance_type"
  
    tags = {
      Name = "usingtf"
    }
}
