module "bucket_utils" {
  source       = "./buckets_module"
}


module "aws_lambda_utils" {
  source       = "./lambda_module"
  kms_key_arn  = module.bucket_utils.kms_key_arn
  token = var.token
}


module "api_gateway_utils" {
  source       = "./api_gateway_module"
  invoke_arn = module.aws_lambda_utils.lambda_function.invoke_arn
  function_name = module.aws_lambda_utils.lambda_function.function_name
}


variable "token" {
  type = string
}