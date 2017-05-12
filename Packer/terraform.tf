provider "aws" {
}

resource "aws_vpc" "hashi_vpc"{
  assign_generated_ipv6_cidr_block = "false"
  cidr_block = "10.0.0.0/16"
  enable_classiclink = "false"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  instance_tenancy = "default"
  
  tags {
    Name = "HashiVPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.hashi_vpc.id}"

  tags {
    Name = "HashiVPN_IGW"
  }
}


resource "aws_subnet" "HashiWebnet_USE1a_Pub" {
  assign_ipv6_address_on_creation = "false"
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  vpc_id = "vpc-12fe176b"

  tags {
    Name = "HashiWebnet_USE1a_Pub"
  }
}

resource "aws_subnet" "HashiWebnet_USE1b_Pub" {
  assign_ipv6_address_on_creation = "false"
  availability_zone = "us-east-1b"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  vpc_id = "vpc-12fe176b"

  tags {
    Name = "HashiWebnet_USE1b_Pub"
  }
}

resource "aws_subnet" "HashiWebnet_USE1c_Pub" {
  assign_ipv6_address_on_creation = "false"
  availability_zone = "us-east-1c"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  vpc_id = "vpc-12fe176b"

  tags {
    Name = "HashiWebnet_USE1c_Pub"
  }
}



resource "aws_subnet" "HashiAppnet_USE1b_Priv" {
  assign_ipv6_address_on_creation = "false"
  availability_zone = "us-east-1b"
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  vpc_id = "vpc-12fe176b"

  tags {
    Name = "HashiAppnet_USE1b_Priv"
  }
}




resource "aws_instance" "web1" {

  ami           = "ami-7d0f786b"
  vpc_security_group_ids = ["sg-4bda6435"]
  instance_type = "t2.micro"
  subnet_id = "subnet-7a55af56"
  key_name = "AWSKeyPair"


  tags {
    Name = "Hashi_Web1"
    consul = "tagged"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 777 /usr/share/nginx/html/index.html"]
  }

  provisioner "file" {
    source      = "files/index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -m 777 /etc/consul.d"]
  }

  provisioner "file" {
    source      = "files/basic_config.json"
    destination = "/etc/consul.d/basic_config.json"
  }

  provisioner "file" {
    source      = "files/web.json"
    destination = "/etc/consul.d/web.json"
  }

  provisioner "remote-exec" {
    inline = ["sudo nohup consul agent -config-dir=/etc/consul.d &",
              "sleep 1"]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("~/.ssh/personal/AWSKeyPair.pem")}"

  }

}

resource "aws_instance" "web2" {

  ami           = "ami-7d0f786b"
  vpc_security_group_ids = ["sg-4bda6435"]
  instance_type = "t2.micro"
  subnet_id = "subnet-9f2790d7"
  key_name = "AWSKeyPair"


  tags {
    Name = "Hashi_Web2"
    consul = "tagged"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 777 /usr/share/nginx/html/index.html"]
  }

  provisioner "file" {
    source      = "files/index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -m 777 /etc/consul.d"]
  }

  provisioner "file" {
    source      = "files/basic_config_server.json"
    destination = "/etc/consul.d/basic_config_server.json"
  }

  provisioner "file" {
    source      = "files/web.json"
    destination = "/etc/consul.d/web.json"
  }

  provisioner "remote-exec" {
    inline = ["sudo nohup consul agent -config-dir=/etc/consul.d &",
              "sleep 1"]
  }


  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("~/.ssh/personal/AWSKeyPair.pem")}"
  }

}

resource "aws_instance" "web3" {

  ami           = "ami-7d0f786b"
  vpc_security_group_ids = ["sg-4bda6435"]
  instance_type = "t2.micro"
  subnet_id = "subnet-9942b2c3"
  key_name = "AWSKeyPair"


  tags {
    Name = "Hashi_Web3"
    consul = "tagged"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 777 /usr/share/nginx/html/index.html"]
  }

  provisioner "file" {
    source      = "files/index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -m 777 /etc/consul.d"]
  }

  provisioner "file" {
    source      = "files/basic_config.json"
    destination = "/etc/consul.d/basic_config.json"
  }

  provisioner "file" {
    source      = "files/web.json"
    destination = "/etc/consul.d/web.json"
  }

  provisioner "remote-exec" {
    inline = ["sudo nohup consul agent -config-dir=/etc/consul.d &",
              "sleep 1"]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("~/.ssh/personal/AWSKeyPair.pem")}"
  }

}

resource "aws_instance" "app2" {

  ami           = "ami-7d0f786b"
  vpc_security_group_ids = ["sg-4ed36d30"]
  instance_type = "t2.micro"
  subnet_id = "subnet-962493de"
  key_name = "AWSKeyPair"


  tags {
    Name = "Hashi_App2"
    consul = "tagged"
  }



}

resource "aws_alb" "HashiALB1" {
  name            = "HashiALB1"
  internal        = false
  security_groups = ["sg-4bda6435"]
  subnets         = ["${aws_subnet.HashiWebnet_USE1a_Pub.id}",
                      "${aws_subnet.HashiWebnet_USE1b_Pub.id}",
                      "${aws_subnet.HashiWebnet_USE1c_Pub.id}"]

  enable_deletion_protection = true

}


resource "aws_alb_target_group" "WebTargetGroup" {
  name     = "HashiWebTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.hashi_vpc.id}"
}

resource "aws_alb_listener" "front_end"{
  load_balancer_arn = "${aws_alb.HashiALB1.arn}"
  port = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.WebTargetGroup.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "alb1" {
  target_group_arn = "${aws_alb_target_group.WebTargetGroup.arn}"
  target_id        = "${aws_instance.web1.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "alb2" {
  target_group_arn = "${aws_alb_target_group.WebTargetGroup.arn}"
  target_id        = "${aws_instance.web2.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "alb3" {
  target_group_arn = "${aws_alb_target_group.WebTargetGroup.arn}"
  target_id        = "${aws_instance.web3.id}"
  port             = 80
}
