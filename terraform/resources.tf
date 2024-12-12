resource "aws_security_group" "web_app_sg" {
  name        = "webapp-sg"
  description = "Web Application Security Group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "web-app"
  }
}

resource "aws_instance" "web_app_instance" {
  ami = var.ami
  subnet_id = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]
  instance_type = var.instance_type
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to the Terraform Web App</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "web-app"
  }
}