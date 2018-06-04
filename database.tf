resource "aws_db_instance" "rds" {
  depends_on             = ["aws_security_group.database"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.database.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.database.id}"
  skip_final_snapshot    = true
}

resource "aws_subnet" "database" {
  count = "${length(distinct(var.database_subnets))}"

  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.database_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  tags              = "${merge(var.tags, map("Name", format("%s-db-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_db_subnet_group" "database" {
  name       = "${lower(var.name)}-db-subnet-grp"
  subnet_ids = ["${aws_subnet.database.*.id}"]
  tags       = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}
