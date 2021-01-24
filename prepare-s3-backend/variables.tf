# Common values

variable "aws_region" {
  default = "us-east-1"
  description = "AWS region"
}

variable "aws_profile" {
  default = "default"                  #use default here
  description = "AWS profile"
}

variable "project_name" {
  default = "eks-webplate-launchpad"
  description = "Some test project name - lowercase"
}
