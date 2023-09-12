terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "external" "whatismyip" {
  program = ["/bin/bash", "${path.module}/util/whatismyip.sh"]
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key
  security_groups = [aws_security_group.secure_access_my_laptop]

  network_interface {
    network_interface_id = var.network_interface_id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

resource "aws_security_group" "secure_access_my_laptop" {

}

resource "aws_security_group_rule" "allow_ssh_from_my_ip" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
  security_group_id = aws_security_group.secure_access_my_laptop
}

resource "aws_security_group_rule" "allow_airbyte_from_my_ip" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
  security_group_id = aws_security_group.secure_access_my_laptop
}
