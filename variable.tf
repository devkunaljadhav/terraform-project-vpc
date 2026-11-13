variable "cidr" {
    type = number
    default = "192.168.0.0/16"
}


variable "availability_zone2" {
    type = string
    default = "ap-south-1a"
}


variable "cidr_block1" {
    type = string
    default = "192.168.1.0/24"
}



variable "cidr_block2" {
    type = string
    default = "192.168.2.0/24"
}


variable "availability_zone3" {
    type = string
    default = "ap-south-1b"
}



variable "cidr_block3" {
    type = string
    default = "0.0.0.0/0"
}


variable "cidr_block4" {
    type = list(string)
    default = ["0.0.0.0/0"]
}   



variable "name" {
    type = string
    default = "web"
}


variable "description1" {
    type = string
    default = "HTTP from VPC"
}



variable "from_port1" {
    type = number
    default = 80
}


variable "to_port1" {
    type = number
    default = 80
}


variable "protocol1" {
    type = string
    default = "tcp"
}


variable "description2" {
    type = string
    default = "SSH"
}


variable "from_port2" {
    type = number
    default = 22
}


