# Common values

variable "aws_region" {
  default = "us-east-1"
  description = "AWS region"
}

variable "aws_profile" {
  default = "default"                  #use default if have only one
  description = "AWS region"
}

variable "project_name" {
  default = "weblate"
  description = "Some project name - lowercase"
}

variable "project_release_link" {
  default = "https://github.com/WeblateOrg/helm/releases/download/weblate-0.2.10/weblate-0.2.10.tgz"
  description = "Helm release link"
}

variable "adminEmail" {
  default = "weblate@admin.com"
  description = "weblate Email of Admin Account"
}
