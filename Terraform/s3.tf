resource "aws_s3_bucket" "tf_s3_bucket" {
  bucket = "nodejs-bucket-987g4"

  tags = {
    Name        = "Nodejs tf bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "tf_s3_object" {
  bucket = aws_s3_bucket.tf_s3_bucket.bucket
  for_each = fileset("E:/AWS/terraform project/Project/nodejs-mysql/public/images", "**") #Meta-argument, here i am providing the path for images folder where we stored the all images
  key    = "images/${each.key}" #name of the object
  source = "E:/AWS/terraform project/Project/nodejs-mysql/public/images/${each.key}" 
}