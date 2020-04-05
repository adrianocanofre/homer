provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "aws-terraform"
}

terraform {
  backend "s3" {
    # Bucket config!
    bucket   = "homer-s3-state"
    key      = "global/s3/terraform.tfstate"
    region   = "us-east-1"
    profile  = "aws-terraform"

   # DynamoDB table config!
   dynamodb_table = "terraform-state-lock-dynamo-homer"
   encrypt        = true
  }
}
