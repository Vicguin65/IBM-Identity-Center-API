variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  default = ""
  sensitive = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  default = ""
  sensitive = true
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}