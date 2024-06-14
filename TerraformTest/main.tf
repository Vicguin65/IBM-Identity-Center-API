provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-west-1"
}

resource "aws_instance" "my_first_instance" {
    ami = "ami-0ca1f30768d0cf0e1"
    instance_type = "t2.xlarge"
    tags = {
        Name = "arnav-terraform-first"
    }
}
