resource "aws_s3_bucket" "terraform-state" {
  bucket = "${var.project_name}-terraform-state"

  block_public_acls   = true
  block_public_policy = true

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
