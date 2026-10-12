output "api_url" {
  value = "${aws_api_gateway_stage.visitor_counter.invoke_url}${aws_api_gateway_resource.counter.path}"
}