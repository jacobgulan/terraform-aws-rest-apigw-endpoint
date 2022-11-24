# Terraform AWS API Gateway REST Endpoint
## Overview
In the module's default form, an API Gateway endpoint is created with non-proxy integration to an AWS Lambda
function. In the case of AWS Lambda, if the lambda successfully executes a 200 response is returned to the
client. If the lambda fails to execute, a 500 response is returned to the client. Additionally, the lambda
may raise custom status codes if the exception raised follows this example format: "400 BadRequest"
