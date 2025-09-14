output "s3_bucket" {
  value = aws_s3_bucket.exports.bucket
}

output "s3_uploader_access_key_id" {
  value = aws_iam_access_key.uploader_key.id
}

output "s3_uploader_secret_access_key" {
  value     = aws_iam_access_key.uploader_key.secret
  sensitive = true
}

output "db_endpoint" {
  value = aws_db_instance.pg.address
}

output "db_port" {
  value = aws_db_instance.pg.port
}
