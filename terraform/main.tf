provider "aws"{
    access_key = ""
    secret_key = ""
    region = "us-west-2"
}

resource "aws_instance" "instance_one"{
    ami = "ami-0cf2b4e024cdb6960"
    instance_type = "t2.micro"
    
    network_interface {
      network_interface_id = aws_network_interface.first_interface.id
      device_index         = 0
  }
}

resource "aws_instance" "instance_two"{
    ami = "ami-0cf2b4e024cdb6960"
    instance_type = "t2.micro"
    
    network_interface {
      network_interface_id = aws_network_interface.second_interface.id
      device_index         = 0
  }
}


resource "aws_vpc" "vpc_main" {

  cidr_block = "10.0.0.0/16"
  tags={
    Name="terraform created VPC"
  }
}

resource "aws_subnet" "subnet_one" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

}

resource "aws_subnet" "subnet_two" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_subnet" "subnet_three" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2c"
}

resource "aws_network_interface" "first_interface" {
  subnet_id   = aws_subnet.subnet_one.id
}

resource "aws_network_interface" "second_interface" {
  subnet_id   = aws_subnet.subnet_two.id
}