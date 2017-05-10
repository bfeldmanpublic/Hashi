provider "aws" {
  access_key = "AKIAIVQGTFOFKTBNOMUQ"
  secret_key = "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"
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

  ami           = "ami-054f2513"
  vpc_security_group_ids = ["sg-4bda6435"]
  instance_type = "t2.micro"
  subnet_id = "subnet-7a55af56"
  key_name = "AWSKeyPair"

  connection {
    user = "ubuntu"
  }

  tags {
    Name = "Hashi_Web1"
  }

}

resource "aws_instance" "web2" {

  ami           = "ami-054f2513"
  vpc_security_group_ids = ["sg-4bda6435"]
  instance_type = "t2.micro"
  subnet_id = "subnet-9f2790d7"
  key_name = "AWSKeyPair"

  connection {
    user = "ubuntu"
  }

  tags {
    Name = "Hashi_Web2"
  }

}

resource "aws_instance" "web3" {

  ami           = "ami-054f2513"
  vpc_security_group_ids = ["sg-4bda6435"]
  instance_type = "t2.micro"
  subnet_id = "subnet-9942b2c3"
  key_name = "AWSKeyPair"

  connection {
    user = "ubuntu"
  }

  tags {
    Name = "Hashi_Web3"
  }

}

resource "aws_instance" "app2" {

  ami           = "ami-054f2513"
  vpc_security_group_ids = ["sg-4ed36d30"]
  instance_type = "t2.micro"
  subnet_id = "subnet-962493de"
  key_name = "AWSKeyPair"

  connection {
    user = "ubuntu"
  }

  tags {
    Name = "Hashi_App2"
  }

}
