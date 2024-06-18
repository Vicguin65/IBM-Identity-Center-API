resource "aws_instance" "hello" {
    ami = var.ami
    instance_type = var.ec2_instance_type
    tags = {
        Name = var.ec2_instance_name
    }
}

output "out" {
  value     = "xyz"
  sensitive = true
}

#externalize 2 and 3