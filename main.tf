# Creating VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

#Creating Subnets
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "cidr_block1"
  availability_zone       = "availability_zone"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "cidr_block2"
  availability_zone       = "availability_zone2"
  map_public_ip_on_launch = true
}

#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

#Creating Route Tables
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "cidr_block3"
    gateway_id = aws_internet_gateway.igw.id
  }
}


#Creating Subnet Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}


#Creating Security Groups
resource "aws_security_group" "webSg" {
  name   = "name"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "description1"
    from_port   = "from_port1"
    to_port     = "to_port1"
    protocol    = "protocol1"
    cidr_blocks = ["cidr_blocks1"]
  }
  ingress {
    description = "description2"
    from_port   = "from_port2"
    to_port     = "to_port2"
    protocol    = "protocol2"
    cidr_blocks = ["cidr_blocks2"]
  }

  egress {
    from_port   = from_port
    to_port     = to_port
    protocol    = "protocol"
    cidr_blocks = ["cidr_blocks4"]
  }

  tags = {
    Name = "Name1"
  }
}

# Creating S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "bucket_name"
}

# Creating Ec2-instance with the VPC
resource "aws_instance" "webserver1" {
  ami                    = "ami1"
  instance_type          = "instance_type1"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data              = base64encode(file("userdata1.sh"))
}

#create alb
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.webSg.id]
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

# Creating Load Balancer
resource "aws_lb_target_group" "tg" {
  name     = "name_alb"
  port     = "port_alb"
  protocol = "protocol_alb"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Attaching Load Balancer
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name
}