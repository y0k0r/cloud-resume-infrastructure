resource "aws_api_gateway_rest_api" "visitor_counter" {
  name        = "cloud-resume-${var.environment}-api"
  description = "API for the cloud resume visitor counter"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "counter" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id
  parent_id   = aws_api_gateway_rest_api.visitor_counter.root_resource_id
  path_part   = "counter"
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  resource_id   = aws_api_gateway_resource.counter.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  resource_id   = aws_api_gateway_resource.counter.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post" {
  rest_api_id             = aws_api_gateway_rest_api.visitor_counter.id
  resource_id             = aws_api_gateway_resource.counter.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.visitor_counter.invoke_arn
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id             = aws_api_gateway_rest_api.visitor_counter.id
  resource_id             = aws_api_gateway_resource.counter.id
  http_method             = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates       = { "application/json" = jsonencode({ statusCode = 200 }) }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.visitor_counter.execution_arn}/${var.environment}/POST/${aws_api_gateway_resource.counter.path_part}"
}

resource "aws_api_gateway_method_response" "post" {
  rest_api_id         = aws_api_gateway_rest_api.visitor_counter.id
  resource_id         = aws_api_gateway_resource.counter.id
  http_method         = aws_api_gateway_method.post.http_method
  status_code         = "200"
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
  response_models     = { "application/json" = "Empty" }
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id         = aws_api_gateway_rest_api.visitor_counter.id
  resource_id         = aws_api_gateway_resource.counter.id
  http_method         = aws_api_gateway_method.options.http_method
  status_code         = "200"
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true, "method.response.header.Access-Control-Allow-Headers" = true, "method.response.header.Access-Control-Allow-Methods" = true }
  response_models     = { "application/json" = "Empty" }
}

resource "aws_api_gateway_integration_response" "post" {
  http_method         = aws_api_gateway_method.post.http_method
  resource_id         = aws_api_gateway_resource.counter.id
  rest_api_id         = aws_api_gateway_rest_api.visitor_counter.id
  status_code         = aws_api_gateway_method_response.post.status_code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'*'" }
  depends_on = [
    aws_api_gateway_integration.post
  ]
}

resource "aws_api_gateway_integration_response" "options" {
  http_method         = aws_api_gateway_method.options.http_method
  resource_id         = aws_api_gateway_resource.counter.id
  rest_api_id         = aws_api_gateway_rest_api.visitor_counter.id
  status_code         = aws_api_gateway_method_response.options.status_code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'*'", "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'", "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'" }
  depends_on = [
    aws_api_gateway_integration.options
  ]
}

resource "aws_api_gateway_deployment" "visitor_counter" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.counter,
      aws_api_gateway_method.post,
      aws_api_gateway_method.options,
      aws_api_gateway_integration.post,
      aws_api_gateway_integration.options,
      aws_api_gateway_method_response.post,
      aws_api_gateway_method_response.options,
      aws_api_gateway_integration_response.post,
      aws_api_gateway_integration_response.options
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "visitor_counter" {
  deployment_id = aws_api_gateway_deployment.visitor_counter.id
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  stage_name    = var.environment
}