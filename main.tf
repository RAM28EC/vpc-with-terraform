resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "pub-sub-1" {
  vpc_id = aws_vpc.terraform-vpc.id
  cidr_block = var.pub-sub1-cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = var.pub-sub1-name
  }
}

resource "aws_subnet" "pub-sub-2" {
  vpc_id = aws_vpc.terraform-vpc.id
  cidr_block = var.pub-sub2-cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = var.pub-sub2-name
  }
}
resource "aws_subnet" "priv-sub-1" {
  vpc_id = aws_vpc.terraform-vpc.id
  cidr_block = var.priv-sub1-cidr
  availability_zone = var.az1
  
  tags = {
    Name = var.priv-sub1-name
  }
}
resource "aws_subnet" "priv-sub-2" {
  vpc_id = aws_vpc.terraform-vpc.id
  cidr_block = var.priv-sub2-cidr
  availability_zone = var.az2
  
  tags = {
    Name = var.priv-sub2-name
  }
}
resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = var.igw-name
  }
}
resource "aws_eip" "ngw-eip" {
  vpc = true
}
resource "aws_nat_gateway" "terraform-ngw" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id = aws_subnet.pub-sub-1.id
  tags = {
    Name = var.nat-gw-name
  }
  depends_on = [aws_internet_gateway.terraform-igw]
}
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.terraform-vpc.id
  route {
    cidr_block = var.pub_rt_cidr
    gateway_id = aws_internet_gateway.terraform-igw.id
  }
  tags = {
    Name = var.pub-rt-name
  }
}
resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.terraform-vpc.id
  route {
    cidr_block = var.priv_rt_cidr
    gateway_id = aws_nat_gateway.terraform-ngw.id
  }
  tags = {
    Name = var.priv-rt-name
  }
}

resource "aws_route_table_association" "pub-rt-sub1-ass" {
  subnet_id = aws_subnet.pub-sub1.id
  route_table_id = aws_route_table.pub-rt.id
}
resource "aws_route_table_association" "pub-rt-sub2-ass" {
  subnet_id = aws_subnet.pub-sub2.id
  route_table_id = aws_route_table.pub-rt.id
}
resource "aws_route_table_association" "priv-rt-sub1-ass" {
  subnet_id = aws_subnet.priv-sub1.id
  route_table_id = aws_route_table.priv-rt.id
  depends_on = [aws_route_table.priv-rt]
}
resource "aws_route_table_association" "priv-rt-sub2-ass" {
  subnet_id = aws_subnet.priv-sub2.id
  route_table_id = aws_route_table.priv-rt.id
  depends_on = [aws_route_table.priv-rt]
}
resource "aws_security_group" "alb-sg" {
  name = var.alb_sg_name
  description = var.alb_sg_description
  vpc_id = aws_vpc.terraform-vpc.id
  depends_on = [aws_vpc.terraform-vpc]
  ingress {
    description = "Allow http traffic"
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    cidr_blocks = var.alb_sg_ingress_cidr_blocks
  }
  ingress {
    description = "Allow ssh traffic"
    from_port = var.ssh_port
    to_port = var.ssh_port
    protocol = "tcp"
    cidr_blocks = var.alb_sg_ingress_cidr_blocks
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = var.alb_sg_ingress_cidr_blocks
  }
  tags = {
    Name = "ALB sg"
  }
}
resource "aws_lb" "pub-sub-alb" {
  name = var.load_balancer_name
  subnets = [aws_subnet.pub-sub1.id, aws_subnet.pub-sub2.id]
  security_groups = [aws_security_group.alb-sg.id]
  load_balancer_type = "application"
  tags = {
    Name = "Pub-Sub-ALB"
  }
}  

resource "aws_lb_target_group" "alb-tg" {
  name = var.target_group_name
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.terraform-vpc.id
  health_check {
    interval = 60
    path = "/"
    port = 80
    protocol = "HTTP"
    timeout = 50
    matcher = "200,202"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.pub-sub-alb.arn
  port = "80"
  protocol = "HTTP"
  default_actions {
    type = "forward"
    target_group_arn = aws_lb_target.alb-tg.arn
  }
}

resource "aws_security_group" "lt-sg" {
  name = var.lt_sg_name
  vpc_id = aws_vpc.terraform-vpc.id
  ingress {
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }
  ingress {
    from_port = var.ssh_port
    to_port = var.ssh_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.lt_sg_egress_cidr_blocks
  }

}
resource "aws_autoscaling_group" "asg" {
  name = var.asg_name
  min_size = var.asg_min
  max_size = var.asg_max
  desired_capacity = var.asg_des_cap
  vpc_zone_identifier = [aws_subnet.priv-sub1.id, aws_subnet.priv-sub2.id]
  launch_template {
    id = aws_launch_template.lt-asg.id
  }
  tag {
    key = "Name"
    value = "Private sub ASG"
    propagate_at_launch = true
  }
}
resource "aws_launch_template" "lt-asg" {
  name = var.lt_asg_name
  image_id = var.lt_asg_ami
  instance_type = var.lt_asg_instance_type
  key_name = var.lt_asg_key
  vpc_security_group_ids = [aws_security_group.lt-asg.id]
  user_data = filebase64("install-apache.sh")
}
resource "aws_autoscaling_attachment" "asg-tg-attachment"{
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn = aws_lb_target_group.alb-tg.arn
}










