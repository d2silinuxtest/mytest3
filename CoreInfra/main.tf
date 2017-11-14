provider aws {}

resource "aws_vpc" "main" {
  cidr_block       = "${var.mycidr}"
  instance_tenancy = "dedicated"

  tags {
    Name        = "MyVPC"
    Application = "MyApp"
  }
}

resource "aws_subnet" "mysubnet1" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "us-west-1a"
  cidr_block        = "10.1.1.0/24"
}
resource "aws_subnet" "mysubnet2" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "us-west-1a"
  cidr_block        = "10.1.10.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "myinternetgw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "MyVPC"
    Application = "MyApp"
  }
}

resource "aws_route_table" "myroutetable" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myinternetgw.id}"
  }

  tags {
    Name = "main"
  }
}

resource "aws_route_table_association" "myroutetableassociation1" {
  subnet_id      = "${aws_subnet.mysubnet1.id}"
  route_table_id = "${aws_route_table.myroutetable.id}"
}
resource "aws_route_table_association" "myroutetableassociation2" {
  subnet_id      = "${aws_subnet.mysubnet2.id}"
  route_table_id = "${aws_route_table.myroutetable.id}"
}

