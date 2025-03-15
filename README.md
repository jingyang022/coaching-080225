### This will be a fully serverless URL Shortener backend. Making use of WAF to ensure that the API Gateway below is only accessible from specific IP addresses. (Details are in 08 Feb Coaching Session labsheet)

<p>Required Components:

1. DynamoDB to store the short ids

2. Created Lambda execution role to access DynamoDB

3. 1x Lambda (for POST /newurl)

4. 1x Lambda (for GET /{shortid})

5. API Gateway with a Custom Domain (Route53) configured with public ACM Cert

6. AWS WAF to ensure that the API Gateway is only accessible from your IP

7. X-ray for tracing

8. Cloudwatch Alarms + SNS for alerts (Don't have to subscribe as this is for learning purposes only)

9. Implemented SYNK scanning workflow to scan terraform files.
