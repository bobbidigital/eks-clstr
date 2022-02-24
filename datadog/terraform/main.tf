
terraform {
    backend "s3" {
        bucket = "allthingsdork-terraform-state"
        key    = "state/datadog/terraform.tfstate"
        region = "us-east-1"

    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_policy" "policy" {
    name  = "datadog_secrets_policy"
    path  = "/"
    description = "Access Secrets associated with Datadog Account"

    policy = jsonencode({

        "Version": "2012-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": [
                "arn:aws:secretsmanager:us-west-2:${var.account_id}:secret:/datadog/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "secretsmanager:ListSecrets",
            "Resource": "*"
        }
    ]
    })

}
