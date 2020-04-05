locals {
  env = lookup(var.envs, terraform.workspace)
  vpc_name = format("vpc-%s", local.env)
}
