resource "aws_instance" "hello" {
    ami = var.ami
    instance_type = var.ec2_instance_type
    tags = {
        Name = var.ec2_instance_name
    }
}

output "out" {
  value     = "Successfully Created"
  sensitive = false
}