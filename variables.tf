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
  description = "REST API resource"
}

variable "http_method" {
  description = "HTTP method. GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS"
  type        = string
}

variable "path_part" {
  description = "Path part of the resource. For example, 'users' in /users"
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
