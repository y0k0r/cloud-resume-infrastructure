output "invoke_url" {
    value = aws_api_gateway_stage.prod.invoke_url
}

output "path" {
    value = aws_api_gateway_resource.update_counter.path
}