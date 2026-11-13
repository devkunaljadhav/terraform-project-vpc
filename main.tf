# Creating VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

# Creating Subnets
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_block1
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_block2
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Creating Route Tables
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.cidr_block3
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Creating Subnet Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

# Creating Security Groups
resource "aws_security_group" "webSg" {
  name   = var.name
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = var.description1
    from_port   = var.from_port1
    to_port     = var.to_port1
    protocol    = var.protocol1
    cidr_blocks = var.cidr_block4
  }

  ingress {
    description = var.description2
    from_port   = var.from_port2
    to_port     = var.to_port2
    protocol    = var.protocol2
    cidr_blocks = var.cidr_block4
  }

  egress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = var.protocol
    cidr_blocks = var.cidr_block4
  }

  tags = {
    Name = "Web-sg"
  }
}

# Creating S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

# Creating EC2 instance within the VPC
resource "aws_instance" "webserver1" {
  ami                    = var.ami1
  instance_type          = var.instance_type1
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file("${path.module}/userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = var.ami1
  instance_type          = var.instance_type1
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data              = base64encode(file("${path.module}/userdata1.sh"))
}

# Create ALB
resource "aws_lb" "myalb" {
  name               = var.name_alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webSg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = var.name
  }
}

# Creating Load Balancer target group
resource "aws_lb_target_group" "tg" {
  name     = "${var.name_alb}-tg"
  port     = var.port_alb
  protocol = var.protocol_alb
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = var.port_alb
  }
}

# Attaching Load Balancer
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = var.port_alb
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = var.port_alb
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = var.port_alb
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}
