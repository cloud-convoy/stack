provider "aws" {
  allowed_account_ids = [local.stack.account]
  region              = local.stack.region

  default_tags {
    tags = {
      Name = local.stack.stack_name
    }
  }
}

data "aws_default_tags" "this" {
  lifecycle {
    postcondition {
      condition     = can(regex("[a-zA-Z][-a-zA-Z0-9]*", self.tags["Name"]))
      error_message = "Member must satisfy regular expression pattern: [a-zA-Z][-a-zA-Z0-9]*"
    }
  }
}
