resource "aws_s3_bucket" "terraform-state" {
  bucket = "${var.project_name}-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.state_key.arn
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }

}

resource "aws_kms_key" "state_key" {
  description = "This key is used to encrypt bucket objects - TERRAFORM STATE"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.terraform-state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
