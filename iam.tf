# Create IAM policy to attach to Lambda execution role to allow access to DynamoDB
resource "aws_iam_policy" "url_dynamoDB_access" {
  name = "url-ddb-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.url-dynamodb-table.arn
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "url_dynamoDB_attach" {
  name       = "url_dynamoDB_attach"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = aws_iam_policy.url_dynamoDB_access.arn
}