output "s3_bucket" {
  value = aws_s3_bucket.terraform-state.bucket
}

output "dynamodb" {
  value = aws_dynamodb_table.terraform_statelock.name
}
