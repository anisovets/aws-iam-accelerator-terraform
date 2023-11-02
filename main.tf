provider "aws" {
    region = var.region
}

terraform {
  backend "s3" {
    bucket = "yaru-labs-terraform-state-bucket"
    key = "iam-pipeline/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "TerraformLocks"
    encrypt = true
  }
}
//DevOps IAM User
resource "aws_iam_user" "infra_provisioning_user" {
    name = "infra_provisioning_service_user"
    path = "/users/"

        lifecycle {
        ignore_changes = [name]
    }
}

//DevOps IAM User
resource "aws_iam_user" "app_user" {
    name = "app_user"
    path = "/users/"

        lifecycle {
        ignore_changes = [name]
    }
}

resource "aws_iam_access_key" "user_access_key" {
    user = aws_iam_user.infra_provisioning_user.name
}

resource "aws_iam_user_policy_attachment" "app_user_permissions" {
  user = aws_iam_user.app_user
  policy_arn = "aws_iam_policy.terraform_backend_access.arn"
}

//Terraform Backend Access Policy
resource "aws_iam_policy" "terraform_backend_access_policy" {
  name = "terraform_backend_access_policy"
  description = ""

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::${var.s3_terraform_state_bucket_name}/*"
      },
      {
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = "arn:aws:s3:::${var.s3_terraform_state_bucket_name}"
      }
    ]
})
}

// Policy for DevOps User 
resource "aws_iam_user_policy" "user_permissions" {
    name = "DevServiceUserAccessPolicy"
    user = aws_iam_user.infra_provisioning_user.name

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action   = [
                    "ecr:*",
                    "s3:*",
                    "s3:*",
                    "rds:*",
                    "ecs:*",
                    "apigateway:*",
                    "vpc:*",
                    "cloudformation:*",
                    "dynamodb:*"
                ],
                Resource = "*"
            }
        ]
    })
}