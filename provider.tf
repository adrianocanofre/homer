provider "aws" {
  region                  = var.region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "aws-terraform"
}

terraform {
  backend "s3" {
    bucket   = "homer-s3-state"
    key      = "global/s3/terraform.tfstate"
    region   = var.region
    profile  = "aws-terraform"

   # DynamoDB table config!
   dynamodb_table = "terraform-state-lock-dynamo-homer"
   encrypt        = true
  }
}
