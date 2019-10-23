resource "aws_iam_role" "cd-push-host-assume-role" {
    name = "cd-push-host-assume-role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "cd-push-host-profile" {
    name = "cd-push-host-profile"
    role = "${aws_iam_role.cd-push-host-assume-role.name}"
}

resource "aws_iam_role_policy" "cd-push-host-policy" {
    name = "cd-push-host-policy"
    role = "${aws_iam_role.cd-push-host-assume-role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllS3List",
            "Effect": "Allow",
            "Action": "s3:List*",
            "Resource": "*"
        },
        {
            "Sid": "BucketsEdit",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::expense-tracker-secrets/*",
                "arn:aws:s3:::expense-tracker-terraform/*"
            ]
        },
        {
            "Sid": "TerraformLockAcquire",
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:Query"
            ],
            "Resource": "arn:aws:dynamodb:::table/terraform-state-lock-dynamo"
        },
        {
            "Sid": "SecretsBucketReadAndList",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::expense-tracker-secrets/*",
                "arn:aws:s3:::expense-tracker-terraform/*"
            ]
        },
        {
            "Sid": "EC2Permissions",
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "PassrolePermissions",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": ["arn:aws:iam:::role/${aws_iam_role.transaction-service-assume-role.name}"]
        }
    ]
}
EOF
}