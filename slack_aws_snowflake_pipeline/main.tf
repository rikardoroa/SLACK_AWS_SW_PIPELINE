module "bucket_utils" {
  source       = "./buckets_module"
}


module "aws_lambda_utils" {
  source       = "./lambda_module"
  kms_key_arn  = module.bucket_utils.kms_key_arn
}


module "api_gateway_utils" {
  source       = "./api_gateway_module"
  lambda_function = module.aws_lambda_utils.lambda_function
}
