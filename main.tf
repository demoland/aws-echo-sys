 /*resource "aws_route53_record" "example" {
#   name = "example.com"
#   type = "A"
#   ttl  = "300"

#   alias {
#     name                   = aws_lb.example.dns_name
#     zone_id                = aws_lb.example.zone_id
#     evaluate_target_health = true
#   }
# }
# */

# locals {
#   private_subnets = "${remote_state.vpc.outputs.private_subnets}"
# }

# resource "aws_lb_target_group" "example" {
#   name_prefix      = "example-tg"
#   port             = var.web_port
#   protocol         = "HTTP"
#   target_type      = "instance"
#   vpc_id           = "var.vpc_id"

#   health_check {
#     interval            = 30
#     path                = "/"
#     port                = var.web_port
#     protocol            = "HTTP"
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
#  lifecycle {
#     create_before_destroy = true
#   }
# }


# Local AMI name string
/*
data "aws_ami" "ubuntu_focal" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["packer_AWS_UBUNTU_20.04_*"]
  }
}
*/

locals {
  public_subnet_0 = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 0)
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  // This AMI is the Ubuntu 20.04 located in us-east-2
  my_ip           = var.my_ip
  cidr_block      = var.cidr_block
  ami_id          = data.aws_ami.ubuntu_focal.image_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_security_group" "web" {
  name_prefix = "web-sg"
  vpc_id      = local.vpc_id

  ingress {
    from_port = local.web_port
    to_port   = local.web_port
    protocol  = "tcp"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  count          = var.instance_count
  ami            = local.ami_id 
  instance_type  = local.instance_type
  key_name       = local.key_name
  security_groups = [local.security_group_id.web]
  subnet_id      = local.public_subnet_0
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install wget jq curl git -y
              EOF
  tags = {
    Name = "example-web-${count.index}"
  }
}

# resource "aws_lb" "example" {
#   name               = "example-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = ["${aws_security_group.example.id}"]
#   subnets            = ["subnet-123456789", "subnet-987654321"]

#   tags = {
#     Name = "example-lb"
#   }
# }

# resource "aws_lb_listener" "example" {
#   load_balancer_arn = aws_lb.example.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.example.arn
#     type             = "forward"
#   }
# }

# resource "aws_lb_target_group" "example" {
#   name_prefix      = "example-tg"
#   port             = var.web_port
#   protocol         = "HTTP"
#   target_type      = "instance"
#   vpc_id           = "vpc-123456789"

#   health_check {
#     interval            = 30
#     path                = "/"
#     port                = var.web_port
#     protocol            = "HTTP"
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }

# resource "aws_lb_target_group_attachment" "example" {
#   target_group_arn = aws_lb_target_group.example.arn
#   target_id        = "${aws_instance.example.*.id}"
#   port             = var.web_port
# }
