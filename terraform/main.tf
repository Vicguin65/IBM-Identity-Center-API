provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc_main" {
  cidr_block = "10.31.0.0/16"

  tags = {
    Name = "terraform-created-vpc"
  }
}

resource "aws_subnet" "subnet_one" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.31.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "subnet-one"
  }
}

resource "aws_subnet" "subnet_two" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.31.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "subnet-two"
  }
}

resource "aws_subnet" "subnet_three" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.31.3.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "subnet-three"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "subnet_one_association" {
  subnet_id      = aws_subnet.subnet_one.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "subnet_two_association" {
  subnet_id      = aws_subnet.subnet_two.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "subnet_three_association" {
  subnet_id      = aws_subnet.subnet_three.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_security_group" "main_sg" {
  name        = "main-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.vpc_main.id

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

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "allow_web"
  }
}

resource "aws_network_interface" "first_interface" {
  subnet_id       = aws_subnet.subnet_one.id
  security_groups = [aws_security_group.main_sg.id]
}

resource "aws_network_interface" "second_interface" {
  subnet_id       = aws_subnet.subnet_two.id
  security_groups = [aws_security_group.main_sg.id]
}

resource "aws_instance" "instance_one" {
  ami               = "ami-0cf2b4e024cdb6960"
  instance_type     = "t2.micro"
  availability_zone = "us-west-2a"
  
  network_interface {
    network_interface_id = aws_network_interface.first_interface.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              echo '<!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Hello World</title>
              </head>
              <body>
                  <h1>Hello World from Web1</h1>
              </body>
              </html>' > /var/www/html/index.html
              EOF

  tags = {
    Name = "web1"
  }
}

resource "aws_instance" "instance_two" {
  ami               = "ami-0cf2b4e024cdb6960"
  instance_type     = "t2.micro"
  availability_zone = "us-west-2b"
  
  network_interface {
    network_interface_id = aws_network_interface.second_interface.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              echo '<!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Hello World</title>
              </head>
              <body>
                  <h1>Hello World from Web2</h1>
              </body>
              </html>' > /var/www/html/index.html
              EOF

  tags = {
    Name = "web2"
  }
}

resource "aws_lb" "main_lb" {
  name               = "main-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_sg.id]
  subnets            = [
    aws_subnet.subnet_one.id,
    aws_subnet.subnet_two.id,
    aws_subnet.subnet_three.id
  ]

  tags = {
    Name = "main-lb"
  }
}

resource "aws_alb_target_group" "main_tg" {
  name     = "my-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_main.id

  health_check {
    path     = "/"
    matcher  = "200"
  }

  tags = {
    Name = "my-alb-target-group"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_alb_target_group.main_tg.arn
  target_id        = aws_instance.instance_one.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_alb_target_group.main_tg.arn
  target_id        = aws_instance.instance_two.id
  port             = 80
}

output "load_balancer_dns_name" {
  value = aws_lb.main_lb.dns_name
}
