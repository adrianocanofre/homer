
module "vpc"{
  source = "./modules/vpc"

  vpc_name  = "homer"
  workspace = local.env

}


module "app_01"{
  source = "./modules/app"

  app_name        = "homer-01"
  workspace       = local.env
  user_data       = file("files/install_nginx.sh")
  public_subnets  = module.vpc.subnet_public
  private_subnets = module.vpc.subnet_private
  vpc             = module.vpc.vpc_id
}
