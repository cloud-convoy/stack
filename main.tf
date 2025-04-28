terraform {
  backend "s3" {
    bucket               = "571600864712"
    encrypt              = true
    key                  = "terraform.tfstate"
    region               = "us-east-1"
    use_lockfile         = true
    workspace_key_prefix = "stacks"
  }
}
