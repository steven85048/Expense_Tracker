resource "aws_ecr_repository" "expense_tracker_ecr" {
  name                 = "expense_tracker_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}