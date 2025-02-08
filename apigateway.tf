# Step 1: Request an ACM Certificate
resource "aws_acm_certificate" "mycert_acm" {
  domain_name       = "yap080225.sctp-sandbox.com" # Our custom domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Step 2: Create Route 53 DNS Record for Validation
resource "aws_route53_record" "cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.mycert_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }


#Step 3: Handle Certificate Validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn

  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn
  ]
}
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.sctp_zone.zone_id
}

/* Ref from previous exercise
resource "aws_acm_certificate_validation" "cert_validation" {

  timeouts {
    create = "5m"
  }
  
  certificate_arn         = aws_acm_certificate.mycert_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}
*/

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
  domain_name = "yap080225.sctp-sandbox.com"  # Our custom domain
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