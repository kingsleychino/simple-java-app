output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "ecs_service_name" {
  value = aws_ecs_service.java_service.name
}