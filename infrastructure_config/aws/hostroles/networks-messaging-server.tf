resource "aws_iam_role" "networks-messaging-server-assume-role" {
    name = "networks-messaging-server-role"

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

resource "aws_iam_instance_profile" "networks-messaging-server-profile" {
    name = "networks-messaging-server-profile"
    role = "${aws_iam_role.transaction-service-assume-role.name}"
}