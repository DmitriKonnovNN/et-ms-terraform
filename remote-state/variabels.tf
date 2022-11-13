variable "local_profile" {
  description = "Paste you local profile AWS_PROFILE"
  type        = string

}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "s3_bucket_name" {
  type = string
}
variable "target_app" {
  type        = string
  description = "what is this infrastructure created for?"
}