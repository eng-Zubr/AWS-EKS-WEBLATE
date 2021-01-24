resource "aws_s3_bucket" "terraform-state" {
  bucket = "${var.project_name}-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {Name = "S3 Remote Terraform State Store"}
}
