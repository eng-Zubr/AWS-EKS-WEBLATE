module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "weblate"

  engine            = "postgres"
  engine_version    = "12.5"
  instance_class    = "db.t2.micro"
  allocated_storage = 5

  name     = "weblate"
  username = "weblate"
  password = random_password.db-password.result
  port     = "5432"

  vpc_security_group_ids = [module.vpc.default_security_group_id, module.weblate-cluster.cluster_primary_security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  create_monitoring_role = false

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres12"

  # DB option group
  major_engine_version = "12"

  # Database Deletion Protection
  deletion_protection = false
}

resource "random_password" "db-password" {
  length = 16
  special = true
  override_special = "_%@"
}
