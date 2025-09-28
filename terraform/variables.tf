variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "ecr_repo_url" {
  type        = string
  description = "ECR repo URL"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag"
}
