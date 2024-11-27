#lambda role and policy
resource "aws_iam_role_policy" "lambda_s3_monitoring" {
  name   = "lambda_logging_with_layer"
  role   = aws_iam_role.iam_for_dev.name
  policy = data.aws_iam_policy_document.pipeline_dev_policy.json
}

# wait 10 seconds until image aprovisioning
resource "null_resource" "wait_for_image" {
  provisioner "local-exec" {
    command = "echo ${var.time_out}"  
  }

  depends_on = [
    null_resource.push_image
  ]
}


# after image aprovisioning, the lambda creation starts using ECR repository
resource "aws_lambda_function" "lambda_function" {
  function_name = "get-apislack-lambda"
  image_uri     = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.iam_for_dev.arn
  timeout =     var.lambda_timeout
  memory_size   = 500
  
    environment {
    variables = {
      bucket = var.curated_bucket
      key = var.kms_key_arn
    }
    }
  depends_on = [
    null_resource.wait_for_image
  ]
}
