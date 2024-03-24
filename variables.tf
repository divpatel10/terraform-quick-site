variable "bucket_name" {
  description = "The name of the S3 bucket for hosting the React application"
  type        = string
}

variable "domain_name" {
  description = "The custom domain name for the React application (optional)"
  type        = string
  default     = ""
}
