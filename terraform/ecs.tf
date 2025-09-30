############################################
# ECS Cluster
############################################
resource "aws_ecs_cluster" "app_cluster" {
  name = "java-app-cluster"
}

############################################
# CloudWatch Logs
############################################
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/java-app"
  retention_in_days = 7
}


############################################
# ECS Task Definition
############################################
resource "aws_ecs_task_definition" "app_task" {
  family                   = "java-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "java-app-container"
      image     = "${aws_ecr_repository.app_repo.repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

############################################
# ECS Service
############################################
resource "aws_ecs_service" "app_service" {
  name            = "java-app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1



  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "java-app-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.app_listener]
}

############################################
# Application Load Balancer
############################################
resource "aws_lb" "app_lb" {
  name               = "java-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

############################################
# Target Group
############################################
resource "aws_lb_target_group" "app_tg" {
  name     = "java-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

############################################
# Listener
############################################
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  depends_on = [aws_lb_target_group.app_tg]
}
