provider "aws" {
  region  = "ap-southeast-2"
  version = "2.70"
}

terraform {
  backend "s3" {}
}

provider "archive" {
  version = "1.3"
}
