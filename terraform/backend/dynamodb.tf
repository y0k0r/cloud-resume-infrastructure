resource "aws_dynamodb_table" "visitor_counter" {
  name         = "counter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "counterName"
  attribute {
    name = "counterName"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "resumeVisitorCounter" {
  table_name = aws_dynamodb_table.visitor_counter.name
  hash_key   = aws_dynamodb_table.visitor_counter.hash_key

  item = <<ITEM
{
  "counterName": {"S": "resumeVisitorCounter"},
  "visitorCounter": {"N": "0"}
}
ITEM
}