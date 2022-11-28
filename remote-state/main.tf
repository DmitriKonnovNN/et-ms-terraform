terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = var.local_profile
  region  = var.aws_region
}

resource "aws_s3_bucket" "terraform_remote_state" {
  bucket        = var.s3_bucket_name
  force_destroy = true
  tags = {
    TargetApp = var.target_app
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_crypto_config" {
  bucket = aws_s3_bucket.terraform_remote_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

  }
}

resource "aws_s3_bucket_versioning" "tf_bucket_version" {
  bucket = aws_s3_bucket.terraform_remote_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform_state_locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  lifecycle {
    prevent_destroy = true
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    TargetApp = var.target_app
  }
}
resource "aws_dynamodb_table" "all_in_one_do_lock" {
  name         = "all_in_one_do_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  lifecycle {
    prevent_destroy = true
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    TargetApp = var.target_app
  }
}

resource "aws_dynamodb_table" "k8s_do_lock" {
  name         = "k8s_do_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  lifecycle {
    prevent_destroy = true
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    TargetApp = var.target_app
  }
}
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_remote_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#resource "aws_s3_bucket_acl" "bucket_acl" {
#  bucket = aws_s3_bucket.terraform_remote_state.id
#  acl    = "private"
#}


#resource "aws_iam_user_policy" "terraform_user_dbtable" {
#  name   = "terraform"
#  user   = data.aws_iam_user.current_user.user_name
#  policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Action": ["dynamodb:*"],
#            "Resource": [
#                "${aws_dynamodb_table.terraform_lock.arn}"
#            ]
#        }
#   ]
#}
#EOF
#}


#resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#  bucket = aws_s3_bucket.terraform_remote_state.id
#  policy = aws_iam_policy.allow_access_from_current_user.policy
#
#}

#resource "aws_iam_policy" "allow_access_from_current_user" {
#  tags = {
#    TargetApp = var.target_app
#  }
#  policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Sid": "",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "${data.aws_iam_user.current_user.arn}"
#            },
#            "Action": "s3:*",
#            "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*"
#        }
#    ]
#}
#EOF
#}


#data "aws_iam_user" "current_user" {
#  user_name = "iamadmin"
#  tags = {
#    TargetApp = var.target_app
#  }
#}