locals { name = "${var.project}-prorodeo" }

# S3 bucket for exports/backups
resource "aws_s3_bucket" "exports" {
  bucket        = var.s3_bucket
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.exports.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lc" {
  bucket = aws_s3_bucket.exports.id
  rule {
    id     = "expire-old-exports"
    status = "Enabled"
    expiration {
      days = 3650
    }
    noncurrent_version_expiration {
      noncurrent_days = 120
    }
  }
}

# IAM user for uploads
resource "aws_iam_user" "uploader" {
  name = "${local.name}-uploader"
}

resource "aws_iam_access_key" "uploader_key" {
  user = aws_iam_user.uploader.name
}

resource "aws_iam_user_policy" "uploader_policy" {
  name   = "${local.name}-s3-upload"
  user   = aws_iam_user.uploader.name
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject", "s3:PutObjectAcl", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.exports.arn,
        "${aws_s3_bucket.exports.arn}/*"
      ]
    }]
  })
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name   = "${local.name}-rds-sg"
  vpc_id = var.vpc_id
  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Subnet group for RDS
resource "aws_db_subnet_group" "subnets" {
  name       = "${local.name}-subnets"
  subnet_ids = var.private_subnet_ids
}

# RDS Postgres
resource "aws_db_instance" "pg" {
  identifier             = "${local.name}-pg"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.m6g.large"
  allocated_storage      = 100
  max_allocated_storage  = 1000
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = true
  storage_encrypted      = true
  backup_retention_period= 7
  deletion_protection    = true
  skip_final_snapshot    = false
}
