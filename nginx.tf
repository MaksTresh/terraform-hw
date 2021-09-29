resource "aws_security_group" "web" {
  name        = "web"
  description = "Web backends security policies."

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_1_cidr}", "${var.vpc_2_cidr}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_1_cidr}", "${var.vpc_2_cidr}"]
  }
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_1_cidr}", "${var.vpc_2_cidr}"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_1_cidr_private}", "${var.vpc_2_cidr_private}"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_1_cidr}", "${var.vpc_2_cidr}"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_1_cidr_private}", "${var.vpc_2_cidr_private}", "${var.vpc_3_cidr_private}"]
  }


  vpc_id = aws_vpc.IS_VPC1.id

  tags = {
    Name        = "Nginx"
    Description = "Security group for backends"
  }
}


resource "aws_instance" "web-1" {
  ami                         = "ami-06d7166bf2ab0265c"
  availability_zone           = "us-east-1b"
  instance_type               = "t2.micro"
  key_name                    = "MyKey"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = aws_subnet.aws-1-subnet-private.id
  source_dest_check           = false
  associate_public_ip_address = false
  monitoring                  = true
  user_data                   = file("nginx_add.sh")
  iam_instance_profile        = aws_iam_instance_profile.s3roacess_iam.name
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = "Nginx 1"
    Description = "Backend server"
    owner       = "Maxim Goglazin"
    project     = "Devops School"
  }
}

resource "aws_instance" "web-2" {
  ami                         = "ami-06d7166bf2ab0265c"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "MyKey"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = aws_subnet.aws-3-subnet-private.id
  source_dest_check           = false
  associate_public_ip_address = false
  monitoring                  = true
  user_data                   = file("nginx_add.sh")
  iam_instance_profile        = aws_iam_instance_profile.s3roacess_iam.name
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = "Nginx 2"
    Description = "Backend server"
    owner       = "Maxim Goglazin"
    project     = "devops school"
    enviroment  = "learning"
  }
}


output "web_ips" {
  value = ["${aws_instance.web-1.*.private_ip}", "${aws_instance.web-2.*.private_ip}"]
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  route_table_ids   = ["${aws_route_table.private_route_table-1.id}"]
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = "${aws_vpc.IS_VPC1.id}"
}