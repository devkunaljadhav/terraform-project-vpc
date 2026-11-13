output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "load_balancer_dns_name" {
  value = aws_lb.myalb.dns_name
}
