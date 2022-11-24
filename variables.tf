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
  type        = list(number)
  description = "List of status codes to map to lambda integration. 200 provided by default."
  default     = [400, 401, 403, 404, 405, 500]
}

# ----------------------------------------------------------------------------
# Method Request Variables
# ----------------------------------------------------------------------------

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
  default     = "AWS"  # non-proxy integration, less bloat
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

variable "request_templates" {
  description = "A map of request templates to be used for the integration. The key should be the content type of the template, and the value should be the template itself. The template can be a string or a file path. The file path must be relative to the root of the module."
  type        = map(string)
  default     = {
    "application/json" = <<-EOT
      "body" : $input.json('$'),
    EOT
  }
}

variable "request_parameters" {
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
  type = list(string)
  default = null
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


# ----------------------------------------------------------------------------
# Method Response Variables
# ----------------------------------------------------------------------------


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
