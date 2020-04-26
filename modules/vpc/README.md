# How to use  

```
module "vpc"{
  source = "vpc"

  vpc_name  = "homer"
  workspace = local.env

}
```


### Input

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azs | The az for the subnets | `list` | `n/a` | `yes` |
| cidr |The cidr block of the desired VPC | `string` | `n/a` | `yes` |
| cidr_public_subnet | The cidr block of the desired subnet | `list` | `n/a` | `yes` |
| cidr_private_subnet | The cidr block of the desired subnet | `list` | `n/a` | `yes` |
| workspace | name of workspace(prod|dev) | `string` | `n/a` | `yes` |
