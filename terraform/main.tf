##d4
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_ami" "docker_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized*"]
  }
}

variable "ec2_key" {
  type = string
}
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"       
  public_key = "${var.ec2_key}"
}

output "key_name" {
  description = "SSH Private Key Name"
  value       = aws_key_pair.ec2_key
}
resource "aws_security_group" "pub" {
  name        = "app-firewall"
  description = "Rules for public outbound"
  vpc_id      = data.aws_vpc.default_vpc.id
}

resource "aws_security_group_rule" "public_outbound" {
  type              = "egress"

  ### all ip addresses
  from_port         = 0
  to_port           = 0

  ### all protocols
  protocol          = "-1"

  ### all ipv4 address
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pub.id
}




resource "aws_security_group_rule" "pub_inbound_ssh" {
  type              = "ingress"

  ### ssh port is 22
  from_port         = 22
  to_port           = 22

  ### ssh works on tcp
  protocol          = "tcp"

  ### allow all ssh traffic from any location
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pub.id
}

resource "aws_security_group_rule" "pub_inbound_http_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pub.id
}

resource "aws_security_group_rule" "public_inbound_https_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pub.id
}



resource "aws_instance" "app_server" {
  ami = data.aws_ami.docker_ami.id
  instance_type = "t2.micro"
  key_name = "ec2_key"
  vpc_security_group_ids = [aws_security_group.pub.id]
  tags = {
      Name = "amongustodo-api"
  }
}