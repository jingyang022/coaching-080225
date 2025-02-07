output "table_arn" {
  value = aws_dynamodb_table.url-dynamodb-table.arn
}

/* output "invoke_url" {
  description = "Invoke URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda-stage.invoke_url
}

output "domain_name" {
  value = data.aws_route53_zone.sctp_zone.name
} */