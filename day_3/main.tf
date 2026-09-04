data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = ["data.aws_vpc.default.id"]
  }
}

#CREATION OF SECURITY GROUPS

resource "aws_security_group" "my_sg" {
    name        = "my-security-group"
    description = "My security group"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
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
        Name = "my-security"
    }
  
}

#creation load balancer

resource "aws_lb_target_group" "my_target_group" {
    name     = "my-target-group"
    port     = 80
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id
    health_check {
        path                = "/"
        interval            = 30
    }
}

resource "aws_lb" "my_load_balancer" {
    name               = "my-load-balancer"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.my_sg.id]
    subnets            = data.aws_subnets.default.ids
  
}

resource "aws_lb_listener" "my_listener" {
    load_balancer_arn = aws_lb.my_load_balancer.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.my_target_group.arn
    }
}

#creation of auto_scaling_group
resource "aws_launch_template" "my_launch_tamplate"{
      name_prefix   = "my-launch-template"
        image_id      = var.ami
        instance_type = var.instance_type
        key_name      = var.key_name
        user_data    = file("/home/ubuntu/Terraform/day_3/user_data.sh")

}

resource "aws_autoscaling_group" "my_asg" {
    name                      = "my-auto-scaling-group"
    max_size                  = 3
    min_size                  = 1
    desired_capacity          = 2
    vpc_zone_identifier       = data.aws_subnets.default.ids
    launch_template {
        id      = aws_launch_template.my_launch_tamplate.id
        version = "$Latest"
    }
    target_group_arns         = [aws_lb_target_group.my_target_group.arn]
    health_check_type         = "ELB"
    health_check_grace_period = 300
}