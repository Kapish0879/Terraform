provider "aws" {
    region = "us-east-1"
    profile = "kapish"
    
  
}

resource "aws_instance" "ec2" {
    ami           = var.ami
    instance_type = var.instance_type
    key_name = "kapish"
  
    tags = {
      Name = "usingtf"
    }
}
