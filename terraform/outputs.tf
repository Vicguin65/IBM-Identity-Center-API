output "alb_dns_name" {
  description = "The DNS name of the load balancers"
  value       = aws_lb.web_alb.dns_name
}
