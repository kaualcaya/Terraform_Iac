    # Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  type = string
}

    #Private Bucket With Tags
resource "aws_s3_bucket_website_configuration" "static_site_bucket" {
  bucket = "sattic-site-${var.bucket_name}"

   index_document {
    suffix = "index.html"
  }

    error_document {
    key = "error.html"
  }

  routing_rule {

    condition {
      key_prefix_equals = "docs/"
    }

    redirect {
      replace_key_prefix_with = "documents/"
    }

  }

}

    #Provides an S3 bucket ACL resource.
resource "aws_s3_bucket_public_access_block" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
  
}

resource "aws_s3_bucket_ownership_controls" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id
  
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "static_site_bucket" {
  depends_on = [ aws_s3_bucket_ownership_controls.static_site_bucket,
                 aws_s3aws_s3_bucket_public_access_block.static_site_bucket ]

  bucket = aws_s3_bucket.static_site_bucket
  acl = "public-read"
}   








