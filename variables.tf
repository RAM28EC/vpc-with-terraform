variable "aws_region" {
  default = "ap-south-1"
  type = string
}

variable "vpc_name" {
    default = "terraform vpc"
    type = string
}
variable "az1" {
    default = "ap-south-1a"
    type = string
}
variable "az2" {
    default = "apa-south-1b"
}
variable "auto-assign-ip" {
    default = "true"
    type = string
}
variable "pub-sub1-name" {
    default = "public subnet 1"
    type = string
}
varaible "pub-sub2-name" {
    default = "public subnet 2"
    type = string
}
variable "priv-sub1-name" {
    default = "private-subnet 1"
    type = string
}
variable "priv-sub2-name" {
    default = "private-subnet-2"
    type= string
}
variable "igw-name" {
    default = "Internet Gateway"
    type = string
}
variable "nat-gw--anme" {
    default = "public route table"
    type = default
}
variable "pub-rt-name" {
    default = "public route table"
    type = string
}
variable "priv-rt-name" {
    default = "Private route table"
    type = string
}
variable "vpc-cidr"{
    default = "10.0.0.0/16"
    type = string
}
varaible "alb_sg_name" {
    type = string
    description = "Name of the application load balancer name"
    default = "alb-sg"
}
variable "alb_sg_description" {
    type = string
    description = "Description of the application load balancer"
    default = "security group for the application load balancer"
}
variable "http_port" {
    type = number
    description = "Port for HTTP traffic"
    default = 80
}
variable "ssh_port" {
    type = number
    description = "port for ssh trafffic"
    default = 22
}
variable "alb_sg_ingress_cidr_blocks" {
    type = list(string)
    description = "List of cidr blocks to allow inbound traffic to the app load balancer security group"
    default = ["0.0.0.0/0"]
}
variable "alb_sg_egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to allow outbound traffic from the App Load Balancer security group"
  default     = ["0.0.0.0/0"]
}
variable "load_balancer_name" {
    type = string
    description = "Name of the load balancer"
    default = "pub-sub-alb"
}
variable "target_group_name" {
    type = string
    description = "Name of the target group"
    default = "alb-sg"
}
variable "lt_sg_name" {
    type = string
    description = "Name of the ASG security group"
    default = "security group for ASG"
}
variable "lt_sg_egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to allow outbound traffic from the ASG security group"
  default     = ["0.0.0.0/0"]
}
variable "asg_name" {
    type = string
    description = "Name of the ASG"
    default = "ASG"
}
variable "lt_asg_name" {
    type = string
    description = "Name of the launch template"
    default = "lt-asg"
}
variable "lt_asg_ami" {
    type = string
    description = "Amazon Linux 2  AMI Id"
    default = "ami-012b9156f755804f5"
}
variable "lt_asg_instance" {
    type = string
    description = "t2 micro instance type"
    default = "t2.micro"
}
variable "lt_asg_key" {
    type = string
    description = "keypair"
    default = "linuxkey"
}
variable "asg_min" {
    type = number
    description = "ASG Min Size"
    default = 2
}
variable "asg_max" {
    type = number
    description = "ASG Max Size"
    default = 4
}
variable "pub_rt_cidr" {
    type = string
    description = "CIDR block to route traffic from internet gateway"
    default = "0.0.0.0./0"
}
variable "priv_rt_cidr" {
  type        = string
  description = "CIDR block to route taffic from private subnet to natgateway"
  default     = "0.0.0.0/0"
}
variable "pub_sub1_cidr" {
    default = "10.0.1.0/24"
    type = string
}
variable "pub_sub2_cidr" {
    default = "10.0.2.0/24"
    type = string
}
variable "priv_sub1_cidr" {
    default = "10.0.3.0/24"
    type = string
}
variable "priv_sub2_cidr" {
    default = "10.0.4.0/24"
    type = string
}
