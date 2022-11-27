##############################################################################
# Example
##############################################################################

module "apigw_endpoint" {
  source  = "app.terraform.io/{YOUR-ORGANIZATION-NAME}/rest-apigw-endpoint/aws"
  version = "0.1.2"

  rest_api_ids = {
    id               = aws_api_gateway_rest_api.api.id
    root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
  }
  http_method = "PUT"
  path_part   = "hello-world"
  uri         = aws_lambda_function.prayer_request.invoke_arn

  allow_origin         = var.env == "dev" ? "*" : "https://mydomain.com"
  request_validator_id = aws_api_gateway_request_validator.api.id
  integration_request_templates = {
    "application/json" = <<-EOT
      {
        "body" : $input.json('$'),
        "method" : "$context.httpMethod"
      }
    EOT
  }
}
