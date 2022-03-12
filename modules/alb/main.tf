#-----------------------------------------------------------------------------------------
# ALB
#-----------------------------------------------------------------------------------------

resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.webserver_sg_id]
  subnets            = [var.pub_subnets[0], var.pub_subnets[1]]
  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.name}-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "alb_attach" {
  count            = var.env == "prd" ? 2 : 1
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2_id[count.index]
  port             = 80
}

resource "aws_lb_listener" "listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"

  }
}
