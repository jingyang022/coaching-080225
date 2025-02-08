resource "aws_acm_certificate" "certificate" {
  domain_name       = "api.yourdomain.com"  # Our custom domain
  validation_method = "DNS"
}

resource "aws_route53_record" "www" {
  name    = aws_acm_certificate.certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.certificate.domain_validation_options[0].resource_record_type
  zone_id = "Z00541411T1NGPV97B5C0"  # Our Route 53 hosted zone ID
  records = [aws_acm_certificate.certificate.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn

  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn
  ]
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "MyAPI"
  description = "API for my application"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_domain_name" "shortener" {
  domain_name = "api.yourdomain.com"  # Our custom domain
  certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn

endpoint configuration {
  types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_base_path_mapping" "shorterner" {
  api_id      = aws_api_gateway_rest_api.api.id
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
}

resource "aws_route53_record" "custom_domain_record" {
  zone_id = "Z00541411T1NGPV97B5C0"  # Our Route 53 hosted zone ID
  name    = aws_api_gateway_domain_name.custom_domain.domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.custom_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.custom_domain.cloudfront_zone_id
    evaluate_target_health = true
  }
}