# creating api gateway object
resource "aws_api_gateway_rest_api" "slackWebhook" {
  name = "slackWebhook"
  description = "Slack API connection"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# creating api gateway path
resource "aws_api_gateway_resource" "slackwebhookpath" {
  parent_id   = aws_api_gateway_rest_api.slackWebhook.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.slackWebhook.id
  path_part   = "SlackGetData"
}

# creating api gateway method
resource "aws_api_gateway_method" "slackwebhookmethod" {
  authorization = "AWS_IAM"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.slackwebhookpath.id
  rest_api_id   =  aws_api_gateway_rest_api.slackWebhook.id
}

# creating api gateway response
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.slackWebhook.id
  resource_id = aws_api_gateway_resource.slackwebhookpath.id
  http_method = aws_api_gateway_method.slackwebhookmethod.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

# creating api gateway lambda integration
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.slackWebhook.id
  resource_id             = aws_api_gateway_resource.slackwebhookpath.id
  http_method             = aws_api_gateway_method.slackwebhookmethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}


# permission to invoke lambda from api gateway
resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name 
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.slackWebhook.execution_arn}/*/*"
}