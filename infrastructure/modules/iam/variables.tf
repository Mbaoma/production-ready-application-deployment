variable "project_name" {
  type = string
}

variable "github_repo" {
  description = "GitHub repository in owner/repo format"
  type        = string
}

variable "github_branch" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "common_tags" {
  type = map(string)
}