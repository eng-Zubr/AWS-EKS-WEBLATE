resource "aws_elasticache_replication_group" "weblate" {
  automatic_failover_enabled    = false
  availability_zones            = ["us-east-1a"]
  replication_group_id          = "tf-rep-weblate"
  replication_group_description = "test weblate"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 1
  parameter_group_name          = "default.redis6.x"
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.weblate.name
  security_group_ids            = [module.vpc.default_security_group_id, module.weblate-cluster.cluster_primary_security_group_id]
}


resource "aws_elasticache_subnet_group" "weblate" {
  name       = "tf-weblate-cache-subnet"
  subnet_ids = module.vpc.private_subnets
}

output "redis" {
  value = aws_elasticache_replication_group.weblate.primary_endpoint_address
}