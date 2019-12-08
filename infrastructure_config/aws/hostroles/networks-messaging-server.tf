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
        },
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
  role = aws_iam_role.networks-messaging-server-assume-role.name
}

resource "aws_iam_role_policy" "networks-messaging-server-policy" {
  name   = "networks-messaging-server-policy"
  role   = aws_iam_role.networks-messaging-server-assume-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetAndListRepository",
            "Effect": "Allow",
            "Action": [
                "ecr:Describe*",
                "ecr:Get*",
                "ecr:List*",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ],
            "Resource": "arn:aws:ecr:us-east-2:003195358776:repository/expense_tracker_ecr"
        },
        {
            "Sid": "GetAuthorization",
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        }
    ]
}   
EOF

}