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


module "teste_homer" {
  source = "git::https://github.com/adrianocanofre/homer.git?ref=v0.0.1"

  app_name  = "teste-homer"
  user_data = file("scripts/userdata.sh")
}
