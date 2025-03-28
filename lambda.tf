data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/package"
  output_path = "${path.module}/package.zip"
}

resource "aws_lambda_function" "http_api_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "yl-http-api"
  description      = "Lambda function"
  runtime          = "python3.13"
  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      APP_URL    = "" # todo: fill with apporpriate value
      MIN_CHAR   = 12
      MAX_CHAR   = 16
      REGION_AWS = "ap-southeast-1"
      DB_NAME    = aws_dynamodb_table.url-dynamodb-table.name
    }
  }
}


# Challenge - keep 7 days log retention for Lambda, 
# Need to run "terraform import aws_cloudwatch_log_group.function_log_group /aws/lambda/yllee9127-topmovies-api" in command line
resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.http_api_lambda.function_name}"
  retention_in_days = 7
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "yl-api-executionrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_exec_role" {
  name = "yl-api-ddbaccess"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "dynamodb:DeleteItem",
                "dynamodb:Scan"
            ],
            "Resource": "${aws_dynamodb_table.table.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_exec_role.arn
}
