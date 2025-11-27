############################################
# LAYER 1 — NETWORKING (VPC + Subnets)
############################################

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "threatcomp-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "threatcomp-igw"
  }
}

# Public Subnet 1
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "threatcomp-public-a"
  }
}

# Public Subnet 2
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24" # different CIDR from public_a
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "threatcomp-public-b"
  }
}

# Route Table (public)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "threatcomp-public-rt"
  }
}

# Associate subnets with the route table
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

############################################
# LAYER 2 — SECURITY GROUPS (ALB + ECS)
############################################

# ALB SG
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # (We’ll terminate HTTPS at ALB later; HTTP only for now)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

# ECS Tasks SG
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow ALB to reach ECS tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # only ALB can hit ECS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-security-group"
  }
}

############################################
# LAYER 3 — LOAD BALANCER (ALB + TG + Listener)
############################################

# ALB
resource "aws_lb" "alb" {
  name               = "threatcomp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = {
    Name = "threatcomp-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name        = "threatcomp-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # required for Fargate

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "threatcomp-tg"
  }
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

############################################
# LAYER 4 — ECS CLUSTER
############################################

resource "aws_ecs_cluster" "threatcomp_cluster" {
  name = "threatcomp-cluster"

  tags = {
    Name = "threatcomp-cluster"
  }
}

############################################
# LAYER 5 — IAM ROLES (Execution + Task Role)
############################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

############################################
# LAYER 6 — TASK DEFINITION
############################################

resource "aws_ecs_task_definition" "task" {
  family                   = "threatcomp-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "threatcomp-container"
      image     = "598130604507.dkr.ecr.eu-west-2.amazonaws.com/threatcomp-app:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      # Run as non-root user (UID 1000)
      user = "1000"

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = "eu-west-2"
          awslogs-group         = "/ecs/threatcomp"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

############################################
# LAYER 7 — ECS SERVICE (Connect to ALB)
############################################

resource "aws_ecs_service" "threatcomp_service" {
  name            = "threatcomp-service"
  cluster         = aws_ecs_cluster.threatcomp_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "threatcomp-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http_listener]
}

############################################
# LAYER 8 — HTTPS + DOMAIN (tm.fazops.com)
############################################

data "aws_route53_zone" "primary" {
  name         = "fazops.com"
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "tm.fazops.com"
  validation_method = "DNS"

  tags = {
    Name = "tm-fazops-com-cert"
  }
}

resource "aws_route53_record" "cert_validation" {
  zone_id = data.aws_route53_zone.primary.zone_id

  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]

  ttl = 60
}


resource "aws_acm_certificate_validation" "cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  depends_on = [
    aws_acm_certificate_validation.cert_validation_complete
  ]
}

resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "tm.fazops.com"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
