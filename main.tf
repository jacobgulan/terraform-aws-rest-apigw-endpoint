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
  integration_http_method = var.integration_http_method
  type                    = var.type

  # OPTIONAL
  connection_type      = var.connection_type
  connection_id        = var.connection_id # only for VPC_LINK
  uri                  = var.uri # REQUIRED for AWS (this is the ARN of the Lambda function)
  credentials          = var.credentials
  request_templates    = var.request_templates
  request_parameters   = var.request_parameters
  passthrough_behavior = var.passthrough_behavior
  cache_key_parameters = var.cache_key_parameters
  cache_namespace      = var.cache_namespace
  content_handling     = var.content_handling
  timeout_milliseconds = var.timeout_milliseconds

  dynamic "tls_config" {
    for_each = var.insecure_skip_verification != null ? [1] : []
    insecure_skip_verification = var.insecure_skip_verification
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
  for_each = local.lambda_status_codes

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = each.key

  # OPTIONAL
  content_handling    = var.content_handling
  response_parameters = null
  response_templates  = null
  selection_pattern   = "${each.key} ${lookup(local.http_status_codes, each.key, null)}"

  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_method_response.method_response
  ]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  count      = var.create_options_method ? 1 : 0
  depends_on = [
    aws_api_gateway_integration.options_integration,
    aws_api_gateway_method_response.options_method_response
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
}

resource "aws_api_gateway_method_response" "method_response" {
  for_each = local.lambda_status_codes

  # REQUIRED
  rest_api_id = var.rest_api_ids.id
  resource_id = local.resource_id
  http_method = var.http_method
  status_code = each.key

  # OPTIONAL
  response_models     = null
  response_parameters = null
}

resource "aws_api_gateway_method_response" "options_method_response" {
  count = var.create_options_method ? 1 : 0
}
