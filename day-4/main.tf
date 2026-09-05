module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
    private_subnet_cidr = "10.0.2.0/24"     
    public_az = "us-east-1a"
    private_az = "us-east-1b"
    sg_name = "my-SG-firewall"
    http_port = 80
    ssh_port = 22
}

module "ec2" {
    source = "./modules/ec2"
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type = "t3.micro"
    key_name = "Kapish-med-erp"
    sg_id = module.vpc.sg_id
    public_subnet_id = module.vpc.public_subnet_id
    private_subnet_id = module.vpc.private_subnet_id
}