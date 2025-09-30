variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "image_tag" {
  type    = string
  default = "latest"
}