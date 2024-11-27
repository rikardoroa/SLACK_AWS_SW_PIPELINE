output "lambda_function" {
  value = aws_lambda_function.lambda_function.name
}


output "invoke_arn" {
  value = aws_lambda_function.lambda_function.arn
}