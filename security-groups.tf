resource "aws_security_group" "database" {
  name        = "${format("RDS-%s-SG", var.name)}"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "TCP"
    security_groups = ["${aws_security_group.private_service_lambda.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", format("RDS-%s-SG", var.name)))}"
}

resource "aws_security_group" "web_public" {
  name        = "${format("WEB-%s-SG", var.name)}"
  description = "Allow http traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", format("WEB-%s-SG", var.name)))}"
}

resource "aws_security_group" "private_service_lambda" {
  name        = "${format("LAMBDA-%s-SG", var.name)}"
  description = "Lambda Security group"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = ["${aws_security_group.web_public.id}"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", format("LAMBDA-%s-SG", var.name)))}"
}
