provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}


terraform {
  backend "s3" {
    bucket = "homer-s3-state"
    key    = "homer/terraform.tfstate"
    region = "us-east-1"
  }
}
