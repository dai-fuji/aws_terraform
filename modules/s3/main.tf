#-----------------------------------------------------------------------------------------
# S3
#-----------------------------------------------------------------------------------------

resource "aws_s3_bucket" "backet" {
  bucket = "${var.name}-${var.env}-mybacket"

  tags = {
    Name = "${var.name}-${var.env}-mybacket"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.backet.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.backet.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
