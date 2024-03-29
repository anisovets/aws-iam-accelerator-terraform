output "iam_user_arn" {
  value       = aws_iam_user.infra_provisioning_user.arn
  description = "ARN of the IAM user."
}

output "iam_user_access_key_id" {
  value       = aws_iam_access_key.user_access_key.id
  description = "Access key ID of the IAM user."
}

output "iam_user_secret_key" {
  value       = aws_iam_access_key.user_access_key.secret
  description = "Secret access key of the IAM user. Note: Handle this with care as it is sensitive."
  sensitive   = true  # This marks the output as sensitive, hiding it by default in the CLI.
}

output "iam_policy_arn" {
  description = "The ARN of the IAM policy for Terraform backend access"
  value       = aws_iam_policy.terraform_backend_access_policy.arn
}