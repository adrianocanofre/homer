## Terraform versions

## Usage

## Examples

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| aws | ~> 2.54 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.54 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_name |  | `string` | `Homer` | no |
| lb_type |  | `string` | `application` | no |
| health_check_path |  | `string` | `/api/healthcheck` | no |
| health_check_healthy_threshold |  | `string` | `3` | no |
| health_check_unhealthy_threshold |  | `string` | `10` | no |
| health_check_timeout |  | `string` | `5` | no |
| health_check_interval |  | `string` | `10` | no |
| health_check_port |  | `string` | `80` | no |
| key_pair |  | `string` | `n/a` | no |
| workspace |  | `string` | `` | no |
| user_data |  | `string` | `` | no |
| ec2_type |  | `string` | `` | no | 
| public_subnets |  | `string` | `` | no |
| private_subnets |  | `string` | `` | no |
| image_mutability |  | `string` | `` | no |
| bucket_name |  | `string` | `` | no |
| version_enable |  | `string` | `` | no |
| create_bucket |  | `string` | `` | no |
| create\_lb | Controls if the Load Balancer should be created | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| target\_groups | A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend\_protocol, backend\_port | `any` | `[]` | no |
| vpc\_id | VPC id where the load balancer and other resources will be deployed. | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| http\_tcp\_listener\_arns | The ARN of the TCP and HTTP load balancer listeners created. |
| http\_tcp\_listener\_ids | The IDs of the TCP and HTTP load balancer listeners created. |
| https\_listener\_arns | The ARNs of the HTTPS load balancer listeners created. |
| https\_listener\_ids | The IDs of the load balancer listeners created. |
| target\_group\_arn\_suffixes | ARN suffixes of our target groups - can be used with CloudWatch. |
| target\_group\_arns | ARNs of the target groups. Useful for passing to your Auto Scaling group. |
| target\_group\_names | Name of the target group. Useful for passing to your CodeDeploy Deployment Group. |
| this\_lb\_arn | The ID and ARN of the load balancer we created. |
| this\_lb\_arn\_suffix | ARN suffix of our load balancer - can be used with CloudWatch. |
| this\_lb\_dns\_name | The DNS name of the load balancer. |
| this\_lb\_id | The ID and ARN of the load balancer we created. |
| this\_lb\_zone\_id | The zone\_id of the load balancer to assist with creating DNS records. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors
## License
