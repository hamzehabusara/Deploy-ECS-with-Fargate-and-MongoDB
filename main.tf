# Create VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-public-subnet"
  }
}

resource "aws_security_group" "app" {
  name_prefix = "my-app-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
}

# Create Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "my-app"
  container_definitions    = data.template_file.container.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu               = "256"
  memory            = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = "omark0/palmhr:mobilesearch"
      environment = [
        {
          name  = "MONGODB_HOST"
          value = "${aws_security_group.mongodb.name}"
        },
        {
          name  = "MONGODB_PORT"
          value = "27017"
        }
      ]
      port_mappings = [
        {
          container_port = 80
          host_port      = 80
          protocol       = "tcp"
        }
      ]
      essential = true
    }
  ])
}

data "template_file" "container" {
  template = file("container.tpl")

  vars = {
    mongodb_name = aws_security_group.mongodb.name
  }
}

# Create Service
resource "aws_ecs_service" "app" {
  name            = "my-app"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = true
  }
}

# Create Security Group for MongoDB
resource "aws_security_group" "mongodb" {
  name_prefix = "my-mongodb-"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create MongoDB Instance
resource "aws_instance" "mongodb" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mongodb.id]
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "my-mongodb"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum install -y amazon-linux-extras
              amazon-linux
