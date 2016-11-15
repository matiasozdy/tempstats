provider "aws" {
    access_key = "MYACCESSKEY"
    secret_key = "MYSECRETKEY"
    region = "us-east-1"
}

#Im using the free tier ub16.04 instance
resource "aws_instance" "tempserv01" {
    ami = "ami-40d28157" 
    instance_type = "t2.micro"
    key_name      = "MYKEY"
    security_groups = ["${aws_security_group.web_server.name}","${aws_security_group.allow_ssh.name}"]
    tags {
        Name = "tempserv01"
    }
  provisioner "file" {
        connection {
          user = "ubuntu"
          host = "${aws_instance.tempserv01.public_ip}"
          agent = "false"
	  timeout = "3m"
          key_file = "keys/MYKEY.pem"
        }
        source = "start.sh"
        destination = "/home/ubuntu/start.sh"
    }

    provisioner "remote-exec" {
        connection {
          user = "ubuntu"
          host = "${aws_instance.tempserv01.public_ip}"
          timeout = "3m"
          key_file = "keys/MYKEY.pem"
        }
        script = "start.sh"
    }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow inbound SSH traffic from anyplace, this should be a range or use VPNC"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow SSH"
  }
}

resource "aws_security_group" "web_server" {
  name = "web server"
  description = "Allow http/s"
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

}
