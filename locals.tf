##############################################################################
# Locals - Variables
##############################################################################

locals {
  parent_id           = var.parent_id == null ? var.rest_api_ids.root_resource_id : var.parent_id
  resource_id         = var.create_api_gateway_resource ? element(concat(aws_api_gateway_resource.resource.*.id, tolist([""])), 0) : local.parent_id
  lambda_status_codes = toset(compact([for status in var.lambda_status_codes : status == 200 ? "" : status])) # removes any possible 200 status from the list

  options_integration_response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.allow_origin}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.allow_methods)}'"
  }
  options_method_response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }

  http_status_codes = {
    "201" = "Created"
    "202" = "Accepted"
    "203" = "NonAuthoritativeInformation"
    "204" = "NoContent"
    "205" = "ResetContent"
    "206" = "PartialContent"
    "207" = "MultiStatus"
    "208" = "AlreadyReported"
    "226" = "IMUsed"
    "300" = "MultipleChoices"
    "301" = "MovedPermanently"
    "302" = "Found"
    "303" = "SeeOther"
    "304" = "NotModified"
    "307" = "TemporaryRedirect"
    "308" = "PermanentRedirect"
    "400" = "BadRequest"
    "401" = "Unauthorized"
    "402" = "PaymentRequired"
    "403" = "Forbidden"
    "404" = "NotFound"
    "405" = "MethodNotAllowed"
    "406" = "NotAcceptable"
    "407" = "ProxyAuthenticationRequired"
    "408" = "RequestTimeout"
    "409" = "Conflict"
    "410" = "Gone"
    "411" = "LengthRequired"
    "412" = "PreconditionFailed"
    "413" = "PayloadTooLarge"
    "414" = "URITooLong"
    "415" = "UnsupportedMediaType"
    "416" = "RangeNotSatisfiable"
    "417" = "ExpectationFailed"
    "418" = "ImATeapot"
    "421" = "MisdirectedRequest"
    "422" = "UnprocessableEntity"
    "423" = "Locked"
    "424" = "FailedDependency"
    "426" = "UpgradeRequired"
    "428" = "PreconditionRequired"
    "429" = "TooManyRequests"
    "431" = "RequestHeaderFieldsTooLarge"
    "451" = "UnavailableForLegalReasons"
    "500" = "InternalServerError" # catch-all regex 
    "501" = "NotImplemented"
    "502" = "BadGateway"
    "503" = "ServiceUnavailable"
    "504" = "GatewayTimeout"
    "505" = "HTTPVersionNotSupported"
    "506" = "VariantAlsoNegotiates"
    "507" = "InsufficientStorage"
    "508" = "LoopDetected"
    "510" = "NotExtended"
    "511" = "NetworkAuthenticationRequired"
  }
}
