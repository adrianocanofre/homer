
module "vpc" {
  source = "./modules/vpc"

  vpc_name            = "homer"
  cidr_public_subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  cidr_private_subnet = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22"]
  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  workspace           = local.env

}


module "app_01" {
  source = "./modules/app"

  app_name        = "homer-01"
  workspace       = local.env
  user_data       = "files/bootstrap.sh"
  public_subnets  = module.vpc.subnet_public
  private_subnets = module.vpc.subnet_private
  vpc_id          = module.vpc.vpc_id
}
