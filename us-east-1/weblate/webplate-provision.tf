provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "weblate" {
  name    = "weblate"
  chart   = var.project_release_link

  depends_on = [module.weblate-cluster.cluster_certificate_authority_data, module.db, aws_elasticache_replication_group.weblate]
  timeout = 900

  set {
    name  = "redis.enabled"
    value = "false"
  }
  set {
    name  = "redis.password"
    value = ""
  }
  set {
    name  = "redis.redisHost"
    value = aws_elasticache_replication_group.weblate.primary_endpoint_address
  }
  set {
    name  = "postgresql.enabled"
    value = "false"
  }
 set {
    name  = "postgresql.postgresqlPassword"
    value = module.db.this_db_instance_password
  }
  set {
    name  = "postgresql.postgresqlUsername"
    value = module.db.this_db_instance_username
  }
  set {
    name  = "postgresql.postgresqlHost"
    value = module.db.this_db_instance_address
  }
  set {
    name  = "postgresql.service.port"
    value = module.db.this_db_instance_port
  }
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "adminEmail"
    value = var.adminEmail
  }
  set {
    name  = "adminPassword"
    value = random_password.admin-password.result
  }
  set {
    name  = "resources.limits.cpu"
    value = "350m"
  }
  set {
    name  = "resources.requests.cpu"
    value = "300m"
  }
}

resource "random_password" "admin-password" {
  length = 16
  special = true
  override_special = "_%@"
}

output "weblate-admin-email" {
  value = var.adminEmail
}

output "weblate-admin-password" {
  value = random_password.admin-password.result
}

resource "null_resource" "get-service" {
  provisioner "local-exec" {
    command = "sleep 30 && aws eks update-kubeconfig  --region us-east-1  --name weblate && kubectl get services"
  }
  depends_on = [helm_release.weblate]
}

resource "null_resource" "hpa" {
  provisioner "local-exec" {
    command = "sleep 30 && kubectl autoscale deployment weblate --cpu-percent=30 --min=1 --max=3"
  }
  depends_on = [helm_release.weblate, null_resource.get-service]
}
