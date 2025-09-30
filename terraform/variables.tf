variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "ecr_repo_url" {
  type    = string
  default = "503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app"
}