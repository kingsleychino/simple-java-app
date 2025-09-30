variable "ecr_repo_url" {
  description = "ECR repository URL"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
