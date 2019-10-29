resource "aws_iam_role" "transaction-service-assume-role" {
    name = "transaction-service-role"

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

resource "aws_iam_instance_profile" "transaction-service-profile" {
    name = "transaction-service-profile"
    role = "${aws_iam_role.transaction-service-assume-role.name}"
}

resource "aws_iam_role_policy" "transaction-service-policy" {
    name = "transaction-service-policy"
    role = "${aws_iam_role.transaction-service-assume-role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SecretsBucketList",
            "Effect": "Allow",
            "Action": [
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::expense-tracker-secrets"
            ]
        },
        {
            "Sid": "SecretsBucketGet",
            "Effect": "Allow",
            "Action": [
                "s3:Get*"
            ],
            "Resource": [
                "arn:aws:s3:::expense-tracker-secrets/*"
            ]
        },
    ]
}   
EOF
}