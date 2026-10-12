data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "visitor_counter" {
  statement {
    sid = "VisitorCounter"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem"
    ]

    resources = [
      aws_dynamodb_table.visitor_counter.arn
    ]
  }
}

resource "aws_iam_role" "visitor_counter" {
  name               = "cloud-resume-${var.environment}-visitor-counter-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "visitor_counter" {
  name   = "cloud-resume-${var.environment}-visitor-counter-dynamodb-policy"
  role   = aws_iam_role.visitor_counter.id
  policy = data.aws_iam_policy_document.visitor_counter.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.visitor_counter.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "visitor_counter" {
  type        = "zip"
  source_file = "visitor_counter.py"
  output_path = "${path.module}/visitor_counter.zip"
}

resource "aws_lambda_function" "visitor_counter" {
  filename      = data.archive_file.visitor_counter.output_path
  function_name = "cloud-resume-${var.environment}-visitor-counter"
  role          = aws_iam_role.visitor_counter.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.visitor_counter.output_base64sha256

  runtime = "python3.13"
}