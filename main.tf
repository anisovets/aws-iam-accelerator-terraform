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

resource "aws_iam_access_key" "user_access_key" {
    user = aws_iam_user.infra_provisioning_user.name
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