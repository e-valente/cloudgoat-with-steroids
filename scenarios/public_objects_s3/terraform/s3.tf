#Secret S3 Bucket
resource "aws_s3_bucket" "cg-public-objects-data-bucket" {
  bucket = "cg-public-objects-data-bucket-${var.cgid}"
  acl = "private"
  force_destroy = true

  tags = {
      Name = "cg-public-objects-data-bucket-${var.cgid}"
      Description = "CloudGoat ${var.cgid} S3 Bucket used for storing sensitive data."
      Stack = var.stack-name
      Scenario = var.scenario-name
  }
}

resource "aws_s3_bucket_public_access_block" "block_bucket" {
  bucket = aws_s3_bucket.cg-public-objects-data-bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_object" "objects" {
for_each = fileset("../assets/", "*")
bucket = aws_s3_bucket.cg-public-objects-data-bucket.id
key = each.value
source = "../assets/${each.value}"
etag = filemd5("../assets/${each.value}")
tags = {
    Stack = var.stack-name
    Scenario = var.scenario-name
  }
}

# Upload our flag
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.cg-public-objects-data-bucket.id
  key    = "flag.txt"
  acl    = "public-read" 
  source = "../flag/flag.txt"
  etag = filemd5("../flag/flag.txt")
}