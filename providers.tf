provider "aws" {
  allowed_account_ids = [local.stack.account]
  region              = local.stack.region

  default_tags {
    tags = {
      Name = local.stack.stack_name
    }
  }
}
