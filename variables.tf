##############################################################################
# Required Variables
##############################################################################

# ----------------------------------------------------------------------------
# Base Configuration Variables
# ----------------------------------------------------------------------------

variable "rest_api_ids" {
  type = object({
    id               = string
    root_resource_id = string
  })
  description = "REST API resource id and root resource id."
}

variable "http_method" {
  description = "HTTP method. GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS"
  type        = string
}

variable "path_part" {
  description = "Path part of the resource. For example, 'users' in /users"
  type        = string
}

variable "uri" {
  description = "The ARN/URI of the target resource"
  type        = string
}


##############################################################################
# Optional Variables
##############################################################################

# ----------------------------------------------------------------------------
# Base Configuration Variables
# ----------------------------------------------------------------------------

variable "create_api_gateway_resource" {
  description = "Whether to create the API Gateway resource"
  type        = bool
  default     = true
}

variable "parent_id" {
  description = "The ID of the parent resource"
  type        = string
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "lambda_status_codes" {
  description = "List of status codes to map to lambda integration. 200 provided by default."
  type        = list(number)
  default     = [400, 401, 403, 404, 405, 500]
}

# ----------------------------------------------------------------------------
# Method Request Variables
# ----------------------------------------------------------------------------

variable "authorization" {
  description = "The type of authorization used for the method. Valid values are NONE for open access, AWS_IAM for using AWS IAM permissions, CUSTOM for using a custom authorizer, or COGNITO_USER_POOLS for using a Cognito user pool."
  type        = string
  default     = "NONE"
}

variable "authorizer_id" {
  description = "The ID of the Authorizer resource to be associated with this method, if the authorizationType is CUSTOM or COGNITO_USER_POOLS."
  type        = string
  default     = null
}

variable "authorization_scopes" {
  description = "A list of the authorization scopes configured on the method. The scopes are used with a COGNITO_USER_POOLS authorizer to authorize the method invocation. The authorization works by matching the method scopes against the scopes parsed from the access token in the incoming request. The method invocation is authorized if any method scopes matches a claimed scope in the access token. Otherwise, the invocation is not authorized. When the method scope is configured, the client must provide an access token instead of an identity token for authorization purposes."
  type        = list(string)
  default     = null
}

variable "api_key_required" {
  description = "Specifies whether the method requires a valid API key."
  type        = bool
  default     = false
}

variable "operation_name" {
  description = "The operation name for the method."
  type        = string
  default     = null
}

variable "method_request_models" {
  description = "A map of the API models used for the request's content type. Key is the content type, value is the model name."
  type        = map(string)
  default     = null
}

variable "method_request_parameters" {
  description = "A map of the required request parameters that can be accepted by the method. Key is the parameter name, value is a boolean flag indicating whether the parameter is required. A parameter is required only if the flag is true and it is not marked as Nullable in the method request's model."
  type        = map(bool)
  default     = null
}

variable "request_validator_id" {
  description = "The ID of the associated Request Validator."
  type        = string
  default     = null
}

# ----------------------------------------------------------------------------
# Integration Request Variables
# ----------------------------------------------------------------------------

variable "integration_http_method" {
  description = "Integration request HTTP method. Defaults to POST for AWS Lambda integration."
  type        = string
  default     = "POST"
}

variable "type" {
  description = "The type of the integration. Valid values: AWS, AWS_PROXY, HTTP, HTTP_PROXY, MOCK"
  type        = string
  default     = "AWS" # non-proxy integration, less bloat
}

variable "connection_type" {
  description = "The type of the network connection to the integration endpoint. Valid values are INTERNET and VPC_LINK."
  type        = string
  default     = null
}

variable "connection_id" {
  description = "The ID of the VPC link for a VPC_LINK integration. Required if connectionType is VPC_LINK."
  type        = string
  default     = null
}

variable "credentials" {
  description = "The credentials required for the integration, if any. For AWS integrations, three options are available. To specify an IAM Role for API Gateway to assume, use the role's Amazon Resource Name (ARN). To require that the caller's identity be passed through from the request, specify the string arn:aws:iam::*:user/*. To use resource-based permissions on supported AWS services, specify null."
  type        = string
  default     = null
}

variable "content_handling" {
  description = "Allows the request payload to be converted to binary or text"
  type        = string
  default     = null
}

variable "integration_request_templates" {
  description = "A map of request templates to be used for the integration. The key should be the content type of the template, and the value should be the template itself. The template can be a string or a file path. The file path must be relative to the root of the module."
  type        = map(string)
  default = {
    "application/json" = <<-EOT
      "body" : $input.json('$'),
    EOT
  }
}

variable "integration_request_parameters" {
  description = "A map of request parameters to be used for the integration. The key should be the method request parameter name, and the value should be the integration request parameter value. The value can be a static value or a JSON path expression."
  type        = map(string)
  default     = null
}

variable "passthrough_behavior" {
  description = "Specifies how to handle request payload content type conversions. Supported values are WHEN_NO_MATCH, WHEN_NO_TEMPLATES, and NEVER."
  type        = string
  default     = "NEVER"
}

variable "cache_key_parameters" {
  description = "A list of request parameters whose values API Gateway caches. If a request contains any of these parameters, API Gateway caches the response."
  type        = list(string)
  default     = null
}

variable "cache_namespace" {
  description = "A string to be used as the cache namespace for the integration."
  type        = string
  default     = null
}

variable "timeout_milliseconds" {
  description = "The timeout in milliseconds for the API Gateway"
  type        = number
  default     = 29000
}

# ----------------------------------------------------------------------------
# Integration Response Variables
# ----------------------------------------------------------------------------

variable "integration_response_templates" {
  description = "Response tempaltes to attach to the integration response. "
  type        = map(string)
  default     = null

}

variable "integration_response_parameters" {
  description = "Response parameters to attach to the integration response."
  type        = map(string)
  default     = null # Default value set in locals. But can be overridden here.
}

# ----------------------------------------------------------------------------
# Method Response Variables
# ----------------------------------------------------------------------------

variable "method_response_success_model" {
  description = "The model to use for method response successes."
  type        = map(string)
  default     = { "application/json" = "Empty" }
}

variable "method_response_error_model" {
  description = "The model to use for method response failures."
  type        = map(string)
  default     = { "application/json" = "Empty" }
}

variable "method_response_parameters" {
  description = "A map of the method response parameters that can be sent back to the caller. Key is the parameter name, value is a boolean flag indicating whether the parameter is required."
  type        = map(bool)
  default     = null
}

# ----------------------------------------------------------------------------
# Options Method
# ----------------------------------------------------------------------------

variable "create_options_method" {
  description = "Whether to create the OPTIONS method"
  type        = bool
  default     = true
}

variable "url" {
  description = "The URL of the frontend"
  type        = string
  default     = "*"
}
