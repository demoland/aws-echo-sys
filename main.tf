/*resource "aws_route53_record" "example" {
  name = "example.com"
  type = "A"
  ttl  = "300"

  alias {
    name                   = aws_lb.example.dns_name
    zone_id                = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}
*/

locals {
  private_subnets = "${remote_state.vpc.outputs.private_subnets}"
}

resource "aws_lb_target_group" "example" {
  name_prefix      = "example-tg"
  port             = var.web_port
  protocol         = "HTTP"
  target_type      = "instance"
  vpc_id           = "var.vpc_id"

  health_check {
    interval            = 30
    path                = "/"
    port                = var.web_port
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
 lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "example" {
  count          = 2
  ami            = "ami-09b44b5f46219ee9c"
  instance_type  = "t2.micro"
  key_name       = var.key_name
  security_groups = ["${aws_security_group.example.id}"]
  subnet_id      = "subnet-123456789"
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

resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.example.id}"]
  subnets            = ["subnet-123456789", "subnet-987654321"]

  tags = {
    Name = "example-lb"
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.example.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "example" {
  name_prefix      = "example-tg"
  port             = var.web_port
  protocol         = "HTTP"
  target_type      = "instance"
  vpc_id           = "vpc-123456789"

  health_check {
    interval            = 30
    path                = "/"
    port                = var.web_port
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "example" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = "${aws_instance.example.*.id}"
  port             = var.web_port
}

resource "aws_security_group" "example" {
  name_prefix = "example-sg"
  vpc_id      = "vpc-123456789"

  ingress {
    from_port = var.web_port
    to_port   = var.web_port
    protocol  = "tcp"
    security_groups = ["${aws_security_group.example.id}"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
