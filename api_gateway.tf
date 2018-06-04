resource "aws_api_gateway_rest_api" "InvoiceAPI" {
  name        = "InvoiceAPI"
  description = "Terraform Serverless API"
}
