<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.97.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.97.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_resourcegroups_group.stack](https://registry.terraform.io/providers/hashicorp/aws/5.97.0/docs/resources/resourcegroups_group) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/5.97.0/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/5.97.0/docs/data-sources/default_tags) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/5.97.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Stack tags that will be applied to all the taggable resources and the stack itself | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account"></a> [account](#output\_account) | The AWS account into which this stack will be deployed |
| <a name="output_region"></a> [region](#output\_region) | The AWS region into which this stack will be deployed (e.g. us-west-2) |
| <a name="output_stack_id"></a> [stack\_id](#output\_stack\_id) | The ID of the stack |
| <a name="output_stack_name"></a> [stack\_name](#output\_stack\_name) | The physical stack name |
<!-- END_TF_DOCS -->