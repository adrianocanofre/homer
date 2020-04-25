
module "vpc"{
  source = "./modules/vpc"

  vpc_name  = "homer"
  workspace = local.env

}
