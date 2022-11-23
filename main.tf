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
  rest_api_id = var.rest_api_ids.id
}

resource "aws_api_gateway_method" "options_method" {
  count = var.create_options_method ? 1 : 0
}



##############################################################################
# Integration Request
##############################################################################

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = var.rest_api_ids.id

}

resource "aws_api_gateway_integration" "options_integration" {
  count = var.create_options_method ? 1 : 0
}


##############################################################################
# Integration Response
##############################################################################

resource "aws_api_gateway_integration_response" "integration_response_success" {
  rest_api_id = var.rest_api_ids.id

  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_integration_response.integration_response,
    aws_api_gateway_method_response.method_response_success
  ]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = var.rest_api_ids.id
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
  rest_api_id = var.rest_api_ids.id
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = var.rest_api_ids.id
}

resource "aws_api_gateway_method_response" "options_method_response" {
  count = var.create_options_method ? 1 : 0
}
