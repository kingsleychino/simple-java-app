variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repo_url" {
  type        = string
  description = "ECR repo URL"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag"
}
