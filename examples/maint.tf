provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}


terraform {
  backend "s3" {
    bucket = "my_bucket"
    key    = "homer/terraform.tfstate"
    region = "us-east-1"
  }
}


module "teste-homer" {
  source  = "git@github.com:adrianocanofre/homer.git"
  version = "v0.0.1"

  app_name  = "teste-homer"
  user_data = file("scripts/userdata.sh")
}
