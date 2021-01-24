resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "${var.project_name}-terraform-lock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {Name = "DynamoDB Terraform State Lock Table"}
}
