output "vpc-id" {
  value = aws_vpc.terraform-vpc.id
}

output "pub-sub1-id" {
    value = aws_subnet.pub-sub-1.id
}
output "pub-sub2-id" {
  value = aws_subnet.pub-sub-2.id
}

output "priv-sub1-id" {
  value = aws_subnet.priv-sub-1.id
}

output "priv-sub2-id" {
  value = aws_subnet.priv-sub-2.id
}

output "terraform-igw" {
  value = aws_internet_gateway.terraform-igw.id
}
output "alb-dns" {
  value = aws_lb.pub-sub-alb.dns_name
}