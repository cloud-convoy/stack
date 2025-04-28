output "account" {
  value = data.aws_caller_identity.this.id
}

output "region" {
  value = data.aws_region.this.name
}
