# Web-acl for terraform distribution
# The web-acl has to be created in singapore region 

resource "aws_wafv2_web_acl" "cf_web_acl" {
  name     = "wx-cf-web-acl"
  scope    = "REGIONAL"
  provider = aws.singapore

  default_action {
    allow {}
  }

  rule {
    name     = "wx-cf-web-acl-rule"
    priority = 1

    action {
      block {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "wx-cf-web-acl-rule"
      sampled_requests_enabled   = true
    }
  }
}