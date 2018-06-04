resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  tags       = "${merge(var.tags, map("Name", format("%s-VPC", var.name)))}"
}

resource "aws_eip" "nat" {
  count = "${length(var.azs)}"
  vpc   = true
  tags  = "${merge(var.tags, map("Name", format("%s-EIP", var.name)))}"
}

resource "aws_nat_gateway" "public-web" {
  count         = "${length(var.azs)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public-web.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.public-web"]
  tags          = "${merge(var.tags, map("Name", format("%s-NAT-GW", var.name)))}"
}

resource "aws_internet_gateway" "public-web" {
  count  = "${length(var.public_subnets) > 1 ? 1 : 0 }"
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-IGW", var.name)))}"
}

resource "aws_subnet" "public-web" {
  count = "${length(distinct(var.public_subnets))}"

  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true
  tags                    = "${merge(var.tags, map("Name", format("%s-public-web-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_subnet" "private-services" {
  count = "${length(distinct(var.private_subnets))}"

  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  tags              = "${merge(var.tags, map("Name", format("%s-service-%s", var.name, element(var.azs, count.index))))}"
}
