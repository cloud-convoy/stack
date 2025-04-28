locals {
  stack = zipmap(["account", "region", "stack_name"], split("_", terraform.workspace))
}
