/**********************************************************************************/
/*                                                                                */
/*                                                                                */
/*                                                                                */
/*                                                                                */
/*    WARNING:  DO NOT MODIFY this file                                           */
/*                                                                                */
/*    An AWS CDK stack is the smallest single unit of deployment. It              */
/*    represents a collection of AWS resources that you define using Terraform    */
/*    resources.                                                                  */
/*                                                                                */
/*    You deploy stacks into an AWS environment. The environment covers a         */
/*    specific AWS account and AWS Region.                                        */
/*                                                                                */
/*                                                                                */
/*                                                                                */
/*                                                                                */
/**********************************************************************************/

terraform {
  backend "s3" {
    bucket               = "cloud-convoy"
    dynamodb_table       = "cloud-convoy"
    encrypt              = true
    key                  = "terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "stacks"
  }
}

locals {
  stack = {
    env = zipmap(["account", "region"], slice(split("_", terraform.workspace), 0, 2))
    id  = split("_", terraform.workspace)[2]
  }
}

variable "description" {
  default     = "Managed by Terraform"
  description = "A description of the stack"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Stack tags that will be applied to all the taggable resources and the stack itself"
  type        = map(string)
}

provider "aws" {
  allowed_account_ids = [local.stack.env.account]
  region              = local.stack.env.region

  default_tags {
    tags = merge(var.tags, {
      "stack:Description" = var.description
      "stack:Environment" = "aws://${local.stack.env.account}/${local.stack.env.region}"
      "stack:StackId"     = local.stack.id
    })
  }
}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

data "aws_default_tags" "this" {
  lifecycle {
    postcondition {
      condition     = can(regex("[a-zA-Z][-a-zA-Z0-9]*", self.tags["stack:StackId"]))
      error_message = "Member must satisfy regular expression pattern: [a-zA-Z][-a-zA-Z0-9]*"
    }
  }
}

resource "aws_resourcegroups_group" "stack" {
  description = "Managed by Terraform"
  name        = "stack-${local.stack.id}"

  tags = {
    Name = "stack-${local.stack.id}"
  }

  resource_query {
    type = "TAG_FILTERS_1_0"

    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]

      TagFilters = [{
        Key    = "stack:StackId"
        Values = [local.stack.id]
      }]
    })
  }
}

output "account" {
  description = "The AWS account into which this stack will be deployed"
  value       = data.aws_caller_identity.this.id
}

output "region" {
  description = "The AWS region into which this stack will be deployed (e.g. us-west-2)"
  value       = data.aws_region.this.name
}

output "stack_id" {
  description = "The ID of the stack"
  value       = local.stack.id
}

output "stack_name" {
  description = "The physical stack name"
  value       = local.stack.id
}
