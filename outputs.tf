##############################################################################
# Outputs
##############################################################################

output "resource_id" {
  description = "The ID of the API Gateway Resource"
  value       = local.resource_id
}

output "integration_response_success" {
  description = "This is the last resource created in the module. This should be used as an explicit dependency for the API Gateway Deployment."
  value       = aws_api_gateway_integration_response.integration_response_success
}
