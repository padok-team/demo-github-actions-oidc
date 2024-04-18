resource "aws_iam_policy" "admin-access" {
  name        = "demo-policy"
  description = "S3 read policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:*"],
            "Resource": ["*"]
        }
    ]
  })
}

resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github" {
  name               = "github-oidc"
  path               = "/"
  assume_role_policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "${aws_iam_openid_connect_provider.default.arn}"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "token.actions.githubusercontent.com:sub": "repo:padok-team/demo-github-actions-oidc:ref:refs/heads/main",
                        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                    }
                }
            }
        ]
    }
  )
}

resource "aws_iam_policy_attachment" "admin-policy" {
  name       = "admin-attachment"
  roles      = [aws_iam_role.github.name]
  policy_arn = aws_iam_policy.admin-access.arn
}
