# Homer

This project create a simple infrastructure in AWS.


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.46 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.46 |


## Resources

| Name |
|------|
| [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) |
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) |
| [aws_lb_target_group_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |
| [aws_subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_name | Nome do projeto | `string` | `"homer"` | no |
| ec2\_type | Instance type(t3.medium, t3.xlarge, etc) | `string` | `"t3.micro"` | no |
| environment | Environment name. | `string` | `"dev"` | no |
| health\_check | A list of maps containing key/value pair. | `any` | <pre>{<br>  "healthy_threshold": 3,<br>  "interval": 30,<br>  "path": "/",<br>  "port": 80,<br>  "protocol": "HTTP",<br>  "timeout": 2,<br>  "unhealthy_threshold": 5<br>}</pre> | no |
| http\_port | Port on which the load balancer is listening. | `number` | `80` | no |
| http\_protocol | Protocol for connections from clients to the load balancer. | `string` | `"HTTP"` | no |
| key\_name | Nome da pem que sera usado para conectar na ec2. | `string` | `"homer"` | no |
| lb\_internal | True  ou false | `bool` | `false` | no |
| lb\_type | Tipo de LB. | `string` | `"application"` | no |
| number\_ec2 | Number of ec2. | `number` | `2` | no |
| subnet\_private\_name | Subnet private name. | `string` | `"homer-private-dev"` | no |
| subnet\_public\_name | Subnet public name. | `string` | `"homer-public-dev"` | no |
| user\_data | The user data to provide when launching the instance. | `string` | `"scripts/userdata.sh"` | no |
| vpc\_name | VPC name. | `string` | `"homer-dev"` | no |

## Outputs

No output.
