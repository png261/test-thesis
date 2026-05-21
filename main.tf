terraform {
  backend "s3" {
    bucket  = "thesis-tofu-state-649519997247"
    key     = "demo/drift-detection/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "ap-southeast-1" }

resource "aws_s3_bucket" "test_bucket" {
  bucket = "cloudrift-demo-bucket-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_versioning" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_security_group" "chapter4_demo" {
  name        = "chapter4_demo"
  description = "Demo security group"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" { default = true }

resource "random_id" "suffix" { byte_length = 4 }
