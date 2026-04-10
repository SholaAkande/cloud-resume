terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-code"
  output_path = "${path.module}/lambda-code/lambda_function.zip"
}

resource "aws_lambda_function" "my_func"{
  filename        = "${path.module}/lambda-code/lambda_function.zip"
  function_name   = "shola-resume-func"
  role            = aws_iam_role.iam_for_lambda.arn
  handler         = "func.lambda_handler"
  runtime         = "python3.9"

  depends_on = [ aws_iam_role_policy_attachment.lambda_logs]
}

resource "aws_dynamodb_table" "resume_stats" {
  name         = "shola-cloud-resume-stats-2026"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "shola-resume-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_lambda_policy" {
  name        = "shola-dynamodb-lambda-policy"
  description = "IAM policy for DynamoDB access from Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.resume_stats.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_policy.arn
}

# 1. Create the API Gateway Container
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "vistor-counter-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"] # This allows your website to talk to the API from anywhere
    allow_methods = ["GET", "POST"]
  }
}

# 2. Create the "Route" (The URL path, e.g., /get-views)
resource "aws_apigatewayv2_route" "counter_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /get-views"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 3. The "Integration" (The bridge between API and Lambda)
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.lambda_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.my_func.invoke_arn
}

# 4. The "Stage" (The environment, like 'production')
resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true
}

# 5. The Permission (Crucial: Telling Lambda it's okay for API Gateway to call it)
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}

# 6. Output the URL so we can find it easily
output "base_url" {
  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}