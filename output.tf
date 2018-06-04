output "region" {
  description = "Region we created the resources in."
  value       = "${var.region}"
}

output "availability_zones" {
  description = "Availability zones"
  value       = "${var.azs}"
}

output "Environments" {
  description = "Environment Tags"
  value       = "${var.tags}"
}

output "vpc" {
  description = "VPC IDs"
  value       = "${aws_vpc.main.id}"
}

output "private-subnet" {
  value = ["${aws_subnet.private-services.*.id}"]
}

output public-subnet {
  value = ["${aws_subnet.public-web.*.id}"]
}

output "database-subnet" {
  value = ["${aws_subnet.database.*.id}"]
}

output "database_subnet_group" {
  value = "${aws_db_subnet_group.database.name}"
}

output "db_instance_id" {
  value = "${aws_db_instance.rds.id}"
}

output "db_instance_address" {
  value = "${aws_db_instance.rds.address}"
}

output "api_base_url" {
  value = "${aws_api_gateway_deployment.InvoiceAPI.invoke_url}"
}

output "lambda" {
  value = "${aws_lambda_function.hello_lambda.qualified_arn}"
}
