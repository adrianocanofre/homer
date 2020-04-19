locals {
  env      = lookup(var.envs, terraform.workspace)
  vpc_name = format("vpc-%s", local.env)
  lb_name  = format("lb-%s", local.env)
  tg_name  = format("tg-%s", local.env)
  tags = {
    Environment = local.env
    Owner       = "terraform"
  }
}
