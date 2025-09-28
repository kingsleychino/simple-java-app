resource "aws_ecr_repository" "app_repo" {
  name = "simple-java-app"
  image_tag_mutability = "MUTABLE"
  tags = { Name = "simple-java-app" }
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}