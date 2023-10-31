provider "aws" {
    region = var.region
}

terraform {
  backend "s3" {
    bucket = "yaru-labs-terraform-state"
    key = "iam-pipeline/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "TerraformLocks"
    encrypt = true
  }
}

resource "aws_iam_user" "new_user" {
    name = "dev_service_user"
    path = "/users/"
}

resource "aws_iam_access_key" "user_access_key" {
    user = aws_iam_user.new_user.name
}

resource "aws_iam_user_policy" "user_permissions" {
    name = "DevServiceUserAccessPolicy"
    user = aws_iam_user.new_user.name

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action   = [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:GetRepositoryPolicy",
                    "ecr:DescribeRepositories",
                    "ecr:ListImages",
                    "ecr:DescribeImages",
                    "ecr:BatchGetImage",
                    "ecr:InitiateLayerUpload",
                    "ecr:UploadLayerPart",
                    "ecr:CompleteLayerUpload",
                    "ecr:PutImage",
                    "ecr:CreateRepository",
                    "ecr:DeleteRepository",
                    "ecr:GetRegistryPolicy",
                    "ecr:SetRepositoryPolicy",
                    "ecr:BatchDeleteImage"

                ],
                Resource = "*"
            }
        ]
    })
}