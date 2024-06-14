provider "aws"{
    access_key = ""
    secret_key = ""
    region = "us-west-1"
}

resource "aws_instance" "hello" {
    ami = "ami-0ca1f30768d0cf0e1"
    instance_type = "t2.micro"
    tags = {
        Name = "hello_terraform"
    }
}

#externalize 2 and 3