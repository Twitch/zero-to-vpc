provider "aws" {
  access_key = "${var.acc_key}"
  secret_key = "${var.priv_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-vpc"
    )
  )}"
}

resource "aws_security_group" "secgrp" {
  name = "${var.pref}-sg"
  description = "${var.whoami} terraformed SG"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = "${var.my_addresses}"
  }
  ingress {
    from_port = -1
    to_port = -1 
    protocol = "icmp"
    cidr_blocks = "${var.my_addresses}"
  }

  ## Allow intra-VPC traffic

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  ## Allow outbound http/https traffic
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  vpc_id = "${aws_vpc.vpc.id}"
  tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-sg"
    )
  )}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-igw"
    )
  )}"    
}

resource "aws_subnet" "subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.vpc_cidr}"
  availability_zone = "${var.az}"
  tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-subnet"
    )
  )}"    
}

resource "aws_route_table" "rtbl" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = "${merge(
    local.my_tags,
     map(
      "Name", "${var.pref}-rtbl"
    )
  )}"
}

resource "aws_route_table_association" "rtbl-assoc" {
  subnet_id = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.rtbl.id}"
}

resource "aws_instance" "jump" {
  count = "1"
  ami = "${var.def_ami}" 
  instance_type = "${var.ins_type}"
  availability_zone = "${var.az}" 
  #availability_zone = "${element(var.azs, count.index)}" 
  key_name = "${var.keypair}"
  vpc_security_group_ids = ["${aws_security_group.secgrp.id}"]
  subnet_id = "${aws_subnet.subnet.id}"
  associate_public_ip_address = true
  volume_tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-jump-ebs-${count.index}"
    )
  )}"

  root_block_device {
    delete_on_termination = true
   }

  tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-jump-${count.index}"
    )
  )}"
  }

resource "aws_instance" "centos7" {
  count = "${var.count}"
  ami = "${var.cent7_ami}" 
  instance_type = "${var.ins_type}"
  availability_zone = "${var.az}" 
  #availability_zone = "${element(var.azs, count.index)}" 
  key_name = "${var.keypair}"
  vpc_security_group_ids = ["${aws_security_group.secgrp.id}"]
  subnet_id = "${aws_subnet.subnet.id}"
  associate_public_ip_address = true
  volume_tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-cent7-ebs-${count.index}"
    )
  )}"

  root_block_device {
    delete_on_termination = true
  }

  tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-centos7-${count.index}"
    )
  )}"
}

resource "aws_instance" "centos6" {
  count = "${var.count}"
  ami = "${var.cent6_ami}" 
  instance_type = "${var.ins_type}"
  availability_zone = "${var.az}" 
  #availability_zone = "${element(var.azs, count.index)}" 
  key_name = "${var.keypair}"
  vpc_security_group_ids = ["${aws_security_group.secgrp.id}"]
  subnet_id = "${aws_subnet.subnet.id}"
  associate_public_ip_address = true
  volume_tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-cent6-ebs-${count.index}"
    )
  )}"

  root_block_device {
    delete_on_termination = true
  }

  tags = "${merge(
    local.my_tags,
    map(
      "Name", "${var.pref}-centos6-${count.index}"
    )
  )}"
}
