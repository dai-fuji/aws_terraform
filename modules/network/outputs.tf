output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "pub_subnets" {
  value = aws_subnet.public.*.id
}
output "pri_subnets" {
  value = aws_subnet.private.*.id
}
