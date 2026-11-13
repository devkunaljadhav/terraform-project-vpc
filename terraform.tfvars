cidr = "192.168.0.0/16"
availability_zone = "ap-south-1a"
availability_zone2 = "ap-south-1b"

cidr_block1 = "192.168.1.0/24"
cidr_block2 = "192.168.2.0/24"
cidr_block3 = "0.0.0.0/0"
cidr_block4 = ["0.0.0.0/0"]

name = "web"

description1 = "HTTP from VPC"
from_port1 = 80
to_port1 = 80
protocol1 = "tcp"

description2 = "SSH"
from_port2 = 22
to_port2 = 22
protocol2 = "tcp"

from_port = 0
to_port = 0
protocol = "-1"

bucket_name = "kunal1625"
ami1 = "ami-02b8269d5e85954ef"
instance_type1 = "t3.micro"

name_alb = "myTG"
port_alb = 80
protocol_alb = "HTTP"
