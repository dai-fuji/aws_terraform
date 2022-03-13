#-----------------------------------------------------------------------------------------
# Security group
#-----------------------------------------------------------------------------------------

resource "aws_security_group" "web_server_sg" {
  name        = "web_server"
  description = "Allow http and https traffic."
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_security_group_rule" "inbound_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg.id
}

resource "aws_security_group_rule" "inbound_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg.id
}

resource "aws_security_group_rule" "inbound_rails" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg.id
}

resource "aws_security_group_rule" "outbound_rails" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg.id
}

#-----------------------------------------------------------------------------------------
# EC2
#-----------------------------------------------------------------------------------------

resource "aws_instance" "ec2" {
  count                       = var.env == "prd" ? 2 : 1
  ami                         = "ami-04204a8960917fd92"
  instance_type               = "t2.micro"
  availability_zone           = var.azs[count.index]
  subnet_id                   = var.pub_subnets[count.index]
  associate_public_ip_address = "true"
  key_name                    = "cfn-key"
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  tags = {
    Name = "${var.name}-ec2-${count.index + 1}"
  }
  user_data = file("modules/ec2/script.sh")

}

resource "aws_network_interface" "netif-ec2" {
  count           = var.env == "prd" ? 2 : 1
  subnet_id       = var.pub_subnets[count.index]
  security_groups = [aws_security_group.web_server_sg.id]
}



