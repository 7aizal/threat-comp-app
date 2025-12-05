output "cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.cluster.id
}

output "ecs_service_name" {
  description = "Name of ECS service"
  value       = aws_ecs_service.service.name
}
