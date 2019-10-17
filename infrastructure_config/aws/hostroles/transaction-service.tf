resource "aws_iam_role" "cd-push-host" {
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
    role = "${aws_iam_role.cd-push-host.name}"
}

resource "aws_iam_role_policy" "cd-push-host-policy" {
    name = "cd-push-host-policy"
    role = "${aws_iam_role.cd-push-host.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SecretsBucketReadAndList",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::expense-tracker-secrets/*"
            ]
        }
    ]
}   
EOF
}