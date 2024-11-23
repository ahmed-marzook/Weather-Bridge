# # Redis Parameter Group
# resource "aws_elasticache_parameter_group" "redis_params" {
#   family      = "redis7"
#   name        = "weather-bridge-redis-params"
#   description = "Parameter group for Weather Bridge Redis"

#   parameter {
#     name  = "maxmemory-policy"
#     value = "allkeys-lru"
#   }
# }

# # Redis Subnet Group - Update to use new subnets
# resource "aws_elasticache_subnet_group" "redis_subnet_group" {
#   name       = "weather-bridge-redis-subnet-group"
#   subnet_ids = [aws_subnet.public.id]
# }

# # Redis Cache Cluster
# resource "aws_elasticache_cluster" "redis_cache" {
#   cluster_id           = "weather-bridge-redis"
#   engine               = "redis"
#   node_type            = "cache.t4g.micro"
#   num_cache_nodes      = 1
#   parameter_group_name = aws_elasticache_parameter_group.redis_params.name
#   port                 = 6379
#   security_group_ids   = [aws_security_group.weather_bridge_sg.id]
#   subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

#   engine_version    = "7.0"
#   apply_immediately = true

#   tags = {
#     Name        = "weather-bridge-redis"
#     Environment = var.environment
#   }
# }