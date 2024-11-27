variable "token" {
  type        = string
  sensitive   = true
  description = "Secret token used by Lambda"
  validation {
    condition     = length(var.token) > 0
    error_message = "The token cannot be empty."
  }
}

module "bucket_utils" {
  source = "./buckets_module"
}

module "aws_lambda_utils" {
  source      = "./lambda_module"
  kms_key_arn = module.bucket_utils.kms_key_arn
  token       = var.token
  depends_on  = [module.bucket_utils]
}

module "api_gateway_utils" {
  source        = "./api_gateway_module"
  invoke_arn    = module.aws_lambda_utils.lambda_function.invoke_arn
  function_name = module.aws_lambda_utils.lambda_function.function_name
  depends_on    = [module.aws_lambda_utils]
}
