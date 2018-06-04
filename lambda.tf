provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "./js/main.js"
  output_path = "./deploy-lambda/hello_lambda.zip"
}

resource "aws_lambda_function" "hello_lambda" {
  function_name = "nodejs_lambda"

  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_sha}"

  role    = "${aws_iam_role.iam_nodejs_lambda.arn}"
  handler = "main.handler"
  runtime = "nodejs6.10"

  vpc_config = {
    subnet_ids         = ["${aws_subnet.private-services.*.id}"]
    security_group_ids = ["${aws_security_group.private_service_lambda.id}"]
  }

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_nodejs_lambda" {
  name               = "${format("IAM-%s-LAMBDA", var.name)}"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_iam_policy" "policy" {
  name        = "new-lambda-policy-attach"
  description = "Policy for lambda security group"

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-policy-attach" {
  role       = "${aws_iam_role.iam_nodejs_lambda.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.InvoiceAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.InvoiceAPI.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.InvoiceAPI.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_lambda" {
  rest_api_id             = "${aws_api_gateway_rest_api.InvoiceAPI.id}"
  resource_id             = "${aws_api_gateway_method.proxy.resource_id}"
  http_method             = "${aws_api_gateway_method.proxy.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.hello_lambda.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.InvoiceAPI.id}"
  resource_id   = "${aws_api_gateway_rest_api.InvoiceAPI.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.InvoiceAPI.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.hello_lambda.invoke_arn}"
}

resource "aws_api_gateway_deployment" "InvoiceAPI" {
  depends_on = [
    "aws_api_gateway_integration.hello_lambda",
    "aws_api_gateway_integration.hello_lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.InvoiceAPI.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.InvoiceAPI.execution_arn}/*/*"
}
