provider "aws" {
    access_key = "Your aws access key"
    secret_key = "your aws secret key"
    region = "us-east-1"
}

resource "aws_instance" "tempserv01" {
    ami = "ami-408c7f28"
    instance_type = "t1.micro"
    key_name      = "your-aws-key-name"
    subnet_id = "${aws_subnet.public_1a.id}"
    vpc_security_group_ids = ["${aws_security_group.web_server.id}","${aws_security_group.allow_ssh.id}"]
    tags {
        Name = "tempserv01"
    }
  provisioner "file" {
        connection {
          user = "ubuntu"
          host = "${aws_instance.tempserv01.public_ip}"
          timeout = "1m"
          key_file = "/path/to/ssh_key"
        }
        source = "start.sh"
        destination = "/home/ubuntu/start.sh"
    }

    provisioner "remote-exec" {
        connection {
          user = "ubuntu"
          host = "${aws_instance.tempserv01.public_ip}"
          timeout = "1m"
          key_file = "keys/aws.pem"
        }
        script = "start.sh"
    }
}

resource "aws_vpc" "tempserver" {
     cidr_block = "10.100.0.0/16"
}

resource "aws_subnet" "public_1a" {
    vpc_id = "${aws_vpc.tempserver.id}"
    cidr_block = "10.100.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"

    tags {
        Name = "Public 1A"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.tempserver.id}"

    tags {
        Name = "Temps gateway"
    }
}


resource "aws_security_group" "allow_ssh" {
  name = "allow_all"
  description = "Allow inbound SSH traffic from my IP"
  vpc_id = "${aws_vpc.tempserver.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["123.123.123.123/32"]
  }

  tags {
    Name = "Allow SSH"
  }
}

resource "aws_security_group" "web_server" {
  name = "web server"
  description = "Allow HTTP and HTTPS traffic in, browser access out."
  vpc_id = "${aws_vpc.tempserver.id}"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web-elb" {
  name = "web-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }


  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  instances = ["${aws_instance.tempserv01.id}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "Web ELB"
  }
}
