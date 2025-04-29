/*
+------------------------------------------------------------------+
|                                                                  |
| scope.tf                                                         |
|                                                                  |
| WARNING:  DO NOT MODIFY this file                                |
|                                                                  |
|           Stacks are deployed into an AWS environment covering a |
|           specific AWS account and region.                       |
|                                                                  |
+------------------------------------------------------------------+
*/

terraform {
  backend "s3" {
    bucket               = "571600864712"
    dynamodb_table       = "571600864712"
    encrypt              = true
    key                  = "terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "stacks"
  }
}

provider "aws" {
  allowed_account_ids = [local.stack.account]
  region              = local.stack.region

  default_tags {
    tags = {
      Name    = local.stack.stack_name
      StackId = "${local.stack.stack_name}-${random_id.stack.b64_url}"
    }
  }
}

locals {
  stack = zipmap(["account", "region", "stack_name"], split("_", terraform.workspace))
}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

data "aws_default_tags" "this" {
  lifecycle {
    postcondition {
      condition     = can(regex("[a-zA-Z][-a-zA-Z0-9]*", self.tags["Name"]))
      error_message = "Member must satisfy regular expression pattern: [a-zA-Z][-a-zA-Z0-9]*"
    }
  }
}

resource "random_id" "stack" {
  byte_length = 8
}

resource "aws_resourcegroups_group" "stack" {
  description = "Managed by Terraform"
  name        = local.stack.stack_name

  resource_query {
    type = "TAG_FILTERS_1_0"

    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]

      TagFilters = [{
        Key    = "StackId"
        Values = [data.aws_default_tags.this.tags["StackId"]]
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
  value       = data.aws_default_tags.this.tags["StackId"]
}

output "stack_name" {
  description = "The physical stack name"
  value       = local.stack.stack_name
}
