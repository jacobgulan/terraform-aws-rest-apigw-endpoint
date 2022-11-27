##############################################################################
# REST API Gateway Endpoint
##############################################################################

resource "aws_api_gateway_resource" "resource" {
  count       = var.create_api_gateway_resource ? 1 : 0
  rest_api_id = var.rest_api_ids.id
  parent_id   = local.parent_id
  path_part   = var.path_part
}


##############################################################################
# Method Request
##############################################################################

resource "aws_api_gateway_method" "method" {
  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method

  # OPTIONAL
  authorization        = var.authorization
  authorizer_id        = var.authorizer_id
  authorization_scopes = var.authorization_scopes
  api_key_required     = var.api_key_required
  operation_name       = var.operation_name
  request_models       = var.method_request_models
  request_validator_id = var.request_validator_id
  request_parameters   = var.method_request_parameters
}

resource "aws_api_gateway_method" "options_method" {
  count = var.create_options_method ? 1 : 0

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = "OPTIONS"

  # OPTIONAL
  authorization        = "NONE"
}


##############################################################################
# Integration Request
##############################################################################

resource "aws_api_gateway_integration" "integration" {
  # REQUIRED
  rest_api_id             = var.rest_api_ids.id
  resource_id             = local.resource_id
  http_method             = var.http_method
  integration_http_method = var.integration_http_method
  type                    = var.type

  # OPTIONAL
  connection_type      = var.connection_type
  connection_id        = var.connection_id # only for VPC_LINK
  uri                  = var.uri           # REQUIRED for AWS (this is the ARN of the Lambda function)
  credentials          = var.credentials
  request_templates    = var.integration_request_templates
  request_parameters   = var.integration_request_parameters
  passthrough_behavior = var.passthrough_behavior
  cache_key_parameters = var.cache_key_parameters
  cache_namespace      = var.cache_namespace
  content_handling     = var.content_handling
  timeout_milliseconds = var.timeout_milliseconds
}

resource "aws_api_gateway_integration" "options_integration" {
  count = var.create_options_method ? 1 : 0

  # REQUIRED
  rest_api_id       = var.rest_api_ids.id
  resource_id       = local.resource_id
  http_method       = aws_api_gateway_method.options_method[0].http_method
  type              = "MOCK"
  request_templates = { "application/json" = jsonencode({ statusCode = 200 }) }
}


##############################################################################
# Integration Response
##############################################################################

resource "aws_api_gateway_integration_response" "integration_response_success" {
  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = "200"

  # OPTIONAL
  response_parameters = var.integration_response_parameters != null ? var.integration_response_parameters : local.options_integration_response_parameters
  response_templates  = var.integration_response_success_template

  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_integration_response.integration_response,
    aws_api_gateway_method_response.method_response_success
  ]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  for_each = local.lambda_status_codes

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = each.key

  # OPTIONAL
  content_handling    = var.content_handling
  selection_pattern   = each.key == "500" ? "(\\n|.)+" : ".*${each.key} ${lookup(local.http_status_codes, each.key, "Request")}.*" # 500 is a catch-all for other errors not caught by the other status codes regex
  response_parameters = var.integration_response_parameters != null ? var.integration_response_parameters : local.options_integration_response_parameters
  response_templates  = var.integration_response_templates != null ? var.integration_response_templates : {
    "application/json" = <<-EOT
      #set($inputRoot = $input.path('$'))
      {
        "httpStatus" : ${each.key},
        "errorType" : "$inputRoot.errorType",
      }
    EOT
  }

  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_method_response.method_response
  ]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  count = var.create_options_method ? 1 : 0

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = aws_api_gateway_method.options_method[0].http_method
  status_code = aws_api_gateway_method_response.options_method_response[0].status_code

  # OPTIONAL
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'${join(",", var.allow_headers)}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.allow_methods)}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.allow_origin}'"
    "method.response.header.Access-Control-Max-Age"       = "'${tostring(var.max_age)}'"
  }

  depends_on = [
    aws_api_gateway_integration.options_integration
  ]
}


##############################################################################
# Method Response
##############################################################################

resource "aws_api_gateway_method_response" "method_response_success" {
  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = "200"

  # OPTIONAL
  response_models     = var.method_response_success_model
  response_parameters = var.method_response_parameters == null ? local.options_method_response_parameters : var.method_response_parameters
}

resource "aws_api_gateway_method_response" "method_response" {
  for_each = local.lambda_status_codes

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = each.key

  # OPTIONAL
  response_models     = tonumber(each.key) >= 400 ? var.method_response_error_model : var.method_response_success_model
  response_parameters = var.method_response_parameters == null ? local.options_method_response_parameters : var.method_response_parameters
}

resource "aws_api_gateway_method_response" "options_method_response" {
  count = var.create_options_method ? 1 : 0

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = aws_api_gateway_method.options_method[0].http_method
  status_code = "200"

  # OPTIONAL
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Max-Age"       = true
  }
}
