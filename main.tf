provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "aakulov-aws3"
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_subnet1
  availability_zone = "eu-central-1b"
}

resource "aws_subnet" "subnet_private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_subnet3
  availability_zone = "eu-central-1c"
}

resource "aws_subnet" "subnet_public" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_subnet2
  availability_zone = "eu-central-1b"
}

resource "aws_subnet" "subnet_public1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_subnet4
  availability_zone = "eu-central-1c"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "aakulov-aws3"
  }
}

resource "aws_eip" "aws3" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.aws3.id
  subnet_id     = aws_subnet.subnet_public.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "aakulov-aws3"
  }
}

resource "aws_route_table" "aws3-private" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "aakulov-aws3-private"
  }
}

resource "aws_route_table" "aws3-public" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "aakulov-aws3-public"
  }
}

resource "aws_route_table_association" "aws3-private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.aws3-private.id
}

resource "aws_route_table_association" "aws3-public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.aws3-public.id
}

resource "aws_security_group" "aws3-internal-sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "aws3-internal-sg"
  tags = {
    Name = "aws3-internal-sg"
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.aws3-lb-sg.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aws3-lb-sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "aws3-lb-sg"
  tags = {
    Name = "aws3-lb-sg"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "aws3" {
  zone_id         = "Z077919913NMEBCGB4WS0"
  name            = "tfe3.anton.hashicorp-success.com"
  type            = "CNAME"
  ttl             = "300"
  records         = [aws_lb.aws3.dns_name]
  allow_overwrite = true
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.aws3.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id         = "Z077919913NMEBCGB4WS0"
  ttl             = 60
  type            = each.value.type
  name            = each.value.name
  records         = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate" "aws3" {
  domain_name       = "tfe3.anton.hashicorp-success.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "aws3" {
  certificate_arn = aws_acm_certificate.aws3.arn
}

resource "aws_lb_target_group" "aws3" {
  name        = "aakulov-aws3"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}

resource "aws_lb" "aws3" {
  name               = "aakulov-aws3"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws3-lb-sg.id]
  subnets            = [aws_subnet.subnet_public.id, aws_subnet.subnet_public1.id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "aws3" {
  load_balancer_arn = aws_lb.aws3.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.aws3.certificate_arn
  depends_on        = [aws_acm_certificate.aws3]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws3.arn
  }
}

resource "aws_launch_configuration" "aws3" {
  image_id        = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.aws3-internal-sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_placement_group" "aws3" {
  name     = "aws3"
  strategy = "spread"
}

resource "aws_autoscaling_group" "aws3" {
  name                 = "aakulov-aws3"
  launch_configuration = aws_launch_configuration.aws3.name
  min_size             = 2
  max_size             = 5
  force_delete         = true
  placement_group      = aws_placement_group.aws3.id
  vpc_zone_identifier  = [aws_subnet.subnet_private.id, aws_subnet.subnet_private1.id]
  target_group_arns    = [aws_lb_target_group.aws3.arn]
  timeouts {
    delete = "15m"
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_lb.aws3]
}

output "aws_url" {
  value       = aws_route53_record.aws3.name
  description = "Domain name of load balancer"
}

