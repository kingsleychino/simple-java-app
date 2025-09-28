output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}


output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.java_app_service.name
}
