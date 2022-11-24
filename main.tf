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
  authorization        = null
  authorizer_id        = null
  authorization_scopes = null
  api_key_required     = null
  operation_name       = null
  request_models       = null
  request_validator_id = null
  request_parameters   = null
}

resource "aws_api_gateway_method" "options_method" {
  count = var.create_options_method ? 1 : 0

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = "OPTIONS"

  # OPTIONAL
  authorization        = null
  authorizer_id        = null
  authorization_scopes = null
  api_key_required     = null
  operation_name       = null
  request_models       = null
  request_validator_id = null
  request_parameters   = null
}


##############################################################################
# Integration Request
##############################################################################

resource "aws_api_gateway_integration" "integration" {
  # REQUIRED
  rest_api_id             = var.rest_api_ids.id
  resource_id             = local.resource_id
  http_method             = var.http_method
  integration_http_method = var.http_method
  type                    = "AWS" # non-proxy integration # may switch to variable

  # OPTIONAL
  connection_type      = null
  connection_id        = null # only for VPC_LINK
  uri                  = null # REQUIRED for AWS (this is the ARN of the Lambda function)
  credentials          = null
  request_templates    = null
  request_parameters   = null
  passthrough_behavior = null
  cache_key_parameters = null
  cache_namespace      = null
  content_handling     = null
  timeout_milliseconds = null

  tls_config {
    insecure_skip_verification = null
  }
}

resource "aws_api_gateway_integration" "options_integration" {
  count = var.create_options_method ? 1 : 0
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

  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_integration_response.integration_response,
    aws_api_gateway_method_response.method_response_success
  ]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  # TODO: FOR EACH STATUS CODE

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = null

  # OPTIONAL
  content_handling    = null
  response_parameters = null
  response_templates  = null
  selection_pattern   = null

  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_method_response.method_response
  ]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  count      = var.create_options_method ? 1 : 0
  depends_on = [aws_api_gateway_integration.options_integration]
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
}

resource "aws_api_gateway_method_response" "method_response" {
  # TODO: FOR EACH STATUS CODE

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = null

  # OPTIONAL
  response_models     = null
  response_parameters = null
}

resource "aws_api_gateway_method_response" "options_method_response" {
  count = var.create_options_method ? 1 : 0
}
