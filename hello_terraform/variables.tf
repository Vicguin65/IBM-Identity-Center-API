variable "ec2_instance_type" {
    type = string
    default = "t3.micro"
}

variable "ami"{
    type = string
    default = "ami-0ca1f30768d0cf0e1"
}

variable "ec2_instance_name" {
    type = string
    default = "Hello Terraform"
}