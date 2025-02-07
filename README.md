### This would be a fully serverless URL Shortener backend. Making use of WAF we will ensure that the API Gateway below is only accessible from specific IP addresses. (Details are in 08 Feb Coaching Session labsheet)

<p>Required Components:

- API Gateway with a Custom Domain (Route53) configured with public ACM Cert
- 1x Lambda (for POST /newurl)
- 1x Lambda (for GET /{shortid})
- DynamoDB to store the short ids
- AWS WAF to ensure that the API Gateway is only accessible from your IP
- X-ray for tracing
- Cloudwatch Alarms + SNS for alerts (Don't have to subscribe as this is for learning purposes only)
