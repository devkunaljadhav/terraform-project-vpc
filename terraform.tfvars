# Creating VPC
cidr_block  = "192.168.0.0/16"
availability_zone =  "ap-south-1a"


#Creating Subnets
cidr_block1  = "192.168.1.0/24"
availability_zone2 =  "ap-south-1a"
cidr_block2  = "192.168.2.0/24"
availability_zone2 = "ap-south-1b"


#Creating Internet Gateway
cidr_block3 = "0.0.0.0/0"

#Creating Route Tables
#Creating Subnet Association

#Creating Security Groups
name = "web"

description1 = "HTTP from VPC"
from_port1 = "80"
to_port1 = "80"
protocol1 = "tcp"
cidr_blocks1 = "0.0.0.0/0"

description2 = "SSH"
from_port2 = "22"
to_port2 = "22"
protocol2 = "tcp"
cidr_blocks2 = "0.0.0.0/0"

#egress
from_port = "0"
to_port     = "0"
protocol    = "-1"
cidr_blocks4 = ["0.0.0.0/0"]

Name1 = "Web-sg"


# Creating S3 Bucket
bucket_name = "kunal1625"

# Creating Ec2-instance with the VPC
ami1                    = "ami-02b8269d5e85954ef"
instance_type1          = "t3.micro"
vpc_security_group_ids1 = [aws_security_group.webSg.id]


#create alb
name_alb     = "myTG"
port_alb     = 80
protocol_alb = "HTTP"

# Creating Load Balancer
# Attaching Load Balancer