# Check Terraform version
terraform {
  required_version = ">= 0.14.0"

  backend "s3" {
    encrypt = true
    # This is an s3bucket you will need to create in your aws
    # space
    bucket = "eks-weblate-terraform-state" # need to be setted manually!

    # The key should be unique to each stack, because we want to
    # have multiple enviornments alongside each other we set
    # this dynamically in the bitbucket-pipelines.yml with the
    # --backend
    key = "us-east-1/weblate" # need to be setted manually!

    region = "us-east-1" # need to be setted manually!

    # This is a DynamoDB table with the Primary Key set to LockID
    dynamodb_table = "eks-weblate-terraform-lock" # need to be setted manually!
  }
}

# Configure the AWS Provider
provider "aws" {
  region           = var.aws_region
  profile          = var.aws_profile
}