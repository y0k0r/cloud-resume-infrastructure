resource "aws_api_gateway_rest_api" "crc_api" {
  name        = "crcapi"
  description = "An API that serves as a trigger for a Lambda function that reads/updates a visitor counter in DynamoDB."

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "update_counter" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  parent_id   = aws_api_gateway_rest_api.crc_api.root_resource_id
  path_part   = "update-crc-counter"
}

resource "aws_api_gateway_method" "apigw-method-post" {
  rest_api_id   = aws_api_gateway_rest_api.crc_api.id
  resource_id   = aws_api_gateway_resource.update_counter.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "apigw-method-options" {
  rest_api_id   = aws_api_gateway_rest_api.crc_api.id
  resource_id   = aws_api_gateway_resource.update_counter.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api-lambda-integration-post" {
  rest_api_id             = aws_api_gateway_rest_api.crc_api.id
  resource_id             = aws_api_gateway_resource.update_counter.id
  http_method             = aws_api_gateway_method.apigw-method-post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.updateCounter.invoke_arn
}

resource "aws_api_gateway_integration" "api-lambda-integration-options" {
  rest_api_id             = aws_api_gateway_rest_api.crc_api.id
  resource_id             = aws_api_gateway_resource.update_counter.id
  http_method             = aws_api_gateway_method.apigw-method-options.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {"application/json" = "{'statusCode': 200}"}
}

resource "aws_lambda_permission" "api-lambda-permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.updateCounter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.crc_api.execution_arn}/*"
}

resource "aws_api_gateway_method_response" "post_response_200" {
  rest_api_id         = aws_api_gateway_rest_api.crc_api.id
  resource_id         = aws_api_gateway_resource.update_counter.id
  http_method         = aws_api_gateway_method.apigw-method-post.http_method
  status_code         = "200"
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true}
  response_models = {"application/json" = "Empty"}
}

resource "aws_api_gateway_method_response" "options_response_200" {
  rest_api_id         = aws_api_gateway_rest_api.crc_api.id
  resource_id         = aws_api_gateway_resource.update_counter.id
  http_method         = aws_api_gateway_method.apigw-method-options.http_method
  status_code         = "200"
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true, "method.response.header.Access-Control-Allow-Headers" = true, "method.response.header.Access-Control-Allow-Methods" = true}
  response_models = {"application/json" = "Empty"}
}

resource "aws_api_gateway_integration_response" "apigw-integration-response-post" {
  http_method = aws_api_gateway_method.apigw-method-post.http_method
  resource_id = aws_api_gateway_resource.update_counter.id
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  status_code = aws_api_gateway_method_response.post_response_200.status_code
  response_parameters = {"method.response.header.Access-Control-Allow-Origin" = "'*'"}
  depends_on = [
    aws_api_gateway_integration.api-lambda-integration-post
  ]
}

resource "aws_api_gateway_integration_response" "apigw-integration-response-options" {
  http_method = aws_api_gateway_method.apigw-method-options.http_method
  resource_id = aws_api_gateway_resource.update_counter.id
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  status_code = aws_api_gateway_method_response.options_response_200.status_code
  response_parameters = {"method.response.header.Access-Control-Allow-Origin" = "'*'", "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'", "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"}
  depends_on = [
    aws_api_gateway_integration.api-lambda-integration-options
  ]
}

resource "aws_api_gateway_deployment" "crc-api-deploy" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id

  depends_on = [
      aws_api_gateway_integration.api-lambda-integration-post,
      aws_api_gateway_integration.api-lambda-integration-options
  ]
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.crc-api-deploy.id
  rest_api_id   = aws_api_gateway_rest_api.crc_api.id
  stage_name    = "prod"
}